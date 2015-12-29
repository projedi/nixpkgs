{ stdenv, pkgs
, buildPythonPackage
, pyobjc
, pkgname, sha256, description, deps
}:

buildPythonPackage rec {
  name = "${pkgname}-${version}";
  version = pyobjc.version;
  disabled = pyobjc.disabled;

  doCheck = false; # TODO: reenable

  propagatedBuildInputs = deps;

  src = pkgs.fetchurl {
    url = "https://pypi.python.org/packages/source/p/${pkgname}/${pkgname}-${version}.tar.gz";
    sha256 = sha256;
  };

  meta = with stdenv.lib; {
    inherit description;
    homepage = http://pyobjc.sourceforge.net/;
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
