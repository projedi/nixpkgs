{ stdenv, fetchurl, perl, zlib, bzip2, xz, makeWrapper }:

let version = "1.18.2"; in

stdenv.mkDerivation {
  name = "dpkg-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/dpkg/dpkg_${version}.tar.xz";
    sha256 = "192pqjd0c7i91kiqzn3cq2sqp5vivf0079i0wybdc9yhfcm4yj0i";
  };

  postPatch = ''
    # dpkg tries to force some dependents like debian_devscripts to use
    # -fstack-protector-strong - not (yet?) a good idea. Disable for now:
    substituteInPlace scripts/Dpkg/Vendor/Debian.pm \
      --replace "stackprotectorstrong => 1" "stackprotectorstrong => 0"
  '';

  configureFlags = [
    "--disable-dselect"
    "--with-admindir=/var/lib/dpkg"
    "PERL_LIBDIR=$(out)/${perl.libPrefix}"
  ];

  preConfigure = ''
    # Nice: dpkg has a circular dependency on itself. Its configure
    # script calls scripts/dpkg-architecture, which calls "dpkg" in
    # $PATH. It doesn't actually use its result, but fails if it
    # isn't present, so make a dummy available.
    touch $TMPDIR/dpkg
    chmod +x $TMPDIR/dpkg
    PATH=$TMPDIR:$PATH

    for i in $(find . -name Makefile.in); do
      substituteInPlace $i --replace "install-data-local:" "disabled:" ;
    done
  '';

  buildInputs = [ perl zlib bzip2 xz ];
  nativeBuildInputs = [ makeWrapper ];

  postInstall =
    ''
      for i in $out/bin/*; do
        if head -n 1 $i | grep -q perl; then
          wrapProgram $i --prefix PERL5LIB : $out/${perl.libPrefix}
        fi
      done

      mkdir -p $out/etc/dpkg
      cp -r scripts/t/origins $out/etc/dpkg
    '';

  meta = with stdenv.lib; {
    description = "The Debian package manager";
    homepage = http://wiki.debian.org/Teams/Dpkg;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mornfall nckx ];
  };
}
