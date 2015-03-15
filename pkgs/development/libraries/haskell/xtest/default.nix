# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, libXtst, X11 }:

cabal.mkDerivation (self: {
  pname = "xtest";
  version = "0.2";
  sha256 = "118xxx7sydpsvdqz0x107ngb85fggn630ysw6d2ckky75fmhmxk7";
  buildDepends = [ X11 ];
  extraLibraries = [ libXtst ];
  meta = {
    description = "Thin FFI bindings to X11 XTest library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})