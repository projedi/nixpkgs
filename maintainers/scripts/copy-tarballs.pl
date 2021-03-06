#! /usr/bin/env nix-shell
#! nix-shell -i perl -p perl perlPackages.NetAmazonS3 nixUnstable

# This command uploads tarballs to tarballs.nixos.org, the
# content-addressed cache used by fetchurl as a fallback for when
# upstream tarballs disappear or change. Usage:
#
# 1) To upload a single file:
#
#    $ copy-tarballs.pl --file /path/to/tarball.tar.gz
#
# 2) To upload all files obtained via calls to fetchurl in a Nix derivation:
#
#    $ copy-tarballs.pl --expr '(import <nixpkgs> {}).hello'

use strict;
use warnings;
use File::Basename;
use File::Path;
use JSON;
use Net::Amazon::S3;
use Nix::Store;

# S3 setup.
my $aws_access_key_id = $ENV{'AWS_ACCESS_KEY_ID'} or die;
my $aws_secret_access_key = $ENV{'AWS_SECRET_ACCESS_KEY'} or die;

my $s3 = Net::Amazon::S3->new(
    { aws_access_key_id     => $aws_access_key_id,
      aws_secret_access_key => $aws_secret_access_key,
      retry                 => 1,
    });

my $bucket = $s3->bucket("nixpkgs-tarballs") or die;

sub alreadyMirrored {
    my ($algo, $hash) = @_;
    return defined $bucket->get_key("$algo/$hash");
}

sub uploadFile {
    my ($fn, $name) = @_;

    my $md5_16 = hashFile("md5", 0, $fn) or die;
    my $sha1_16 = hashFile("sha1", 0, $fn) or die;
    my $sha256_32 = hashFile("sha256", 1, $fn) or die;
    my $sha256_16 = hashFile("sha256", 0, $fn) or die;
    my $sha512_32 = hashFile("sha512", 1, $fn) or die;
    my $sha512_16 = hashFile("sha512", 0, $fn) or die;

    my $mainKey = "sha512/$sha512_16";

    # Upload the file as sha512/<hash-in-base-16>.
    print STDERR "uploading $fn to $mainKey...\n";
    $bucket->add_key_filename($mainKey, $fn, { 'x-amz-meta-original-name' => $name })
        or die "failed to upload $fn to $mainKey\n";

    # Create redirects from the other hash types.
    sub redirect {
        my ($name, $dest) = @_;
        #print STDERR "linking $name to $dest...\n";
        $bucket->add_key($name, "", { 'x-amz-website-redirect-location' => "/" . $dest })
            or die "failed to create redirect from $name to $dest\n";
    }
    redirect "md5/$md5_16", $mainKey;
    redirect "sha1/$sha1_16", $mainKey;
    redirect "sha256/$sha256_32", $mainKey;
    redirect "sha256/$sha256_16", $mainKey;
    redirect "sha512/$sha512_32", $mainKey;
}

my $op = $ARGV[0] // "";

if ($op eq "--file") {
    my $fn = $ARGV[1] // die "$0: --file requires a file name\n";
    if (alreadyMirrored("sha512", hashFile("sha512", 0, $fn))) {
        print STDERR "$fn is already mirrored\n";
    } else {
        uploadFile($fn, basename $fn);
    }
}

elsif ($op eq "--expr") {

    # Evaluate find-tarballs.nix.
    my $expr = $ARGV[1] // die "$0: --expr requires a Nix expression\n";
    my $pid = open(JSON, "-|", "nix-instantiate", "--eval-only", "--json", "--strict",
                   "<nixpkgs/maintainers/scripts/find-tarballs.nix>",
                   "--arg", "expr", $expr);
    my $stdout = <JSON>;
    waitpid($pid, 0);
    die "$0: evaluation failed\n" if $?;
    close JSON;

    my $fetches = decode_json($stdout);

    print STDERR "evaluation returned ", scalar(@{$fetches}), " tarballs\n";

    # Check every fetchurl call discovered by find-tarballs.nix.
    my $mirrored = 0;
    my $have = 0;
    foreach my $fetch (@{$fetches}) {
        my $url = $fetch->{url};
        my $algo = $fetch->{type};
        my $hash = $fetch->{hash};

        if ($url !~ /^http:/ && $url !~ /^https:/ && $url !~ /^ftp:/ && $url !~ /^mirror:/) {
            print STDERR "skipping $url (unsupported scheme)\n";
            next;
        }

        if (alreadyMirrored($algo, $hash)) {
            $have++;
            next;
        }

        print STDERR "mirroring $url...\n";

        next if $ENV{DRY_RUN};

        # Download the file using nix-prefetch-url.
        $ENV{QUIET} = 1;
        $ENV{PRINT_PATH} = 1;
        my $fh;
        my $pid = open($fh, "-|", "nix-prefetch-url", "--type", $algo, $url, $hash) or die;
        waitpid($pid, 0) or die;
        if ($? != 0) {
            print STDERR "failed to fetch $url: $?\n";
            next;
        }
        <$fh>; my $storePath = <$fh>; chomp $storePath;

        uploadFile($storePath, $url);
        $mirrored++;
    }

    print STDERR "mirrored $mirrored files, already have $have files\n";
}

else {
    die "Syntax: $0 --file FILENAME | --expr EXPR\n";
}
