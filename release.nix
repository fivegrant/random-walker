with import <nixpkgs> {};

let
  config = {
    packageOverrides = pkgs: rec{
      haskellPackages = pkgs.haskellPackages.override {
        overrides = haskellPackagesNew: haskellPackagesOld: rec {
          random-walker = haskellPackages.callPackage ./random-walker.nix {};
	};
      };
    };
  };
  pkgs = import <nixpkgs> { inherit config; };
in 
{
  random-walker = pkgs.haskellPackages.random-walker;
}
