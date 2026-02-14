{
  description = "Utility for signing the RPi EERPOM bootcode";

  inputs = {
    # Latest stable Nixpkgs
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, flake-utils }:
    # Create outputs for a variety of common systems by using flake-utils->eachDefaultSystem to define the "system"
    flake-utils.lib.eachDefaultSystem( system:
      let 
        pkgs = import nixpkgs { inherit system; };
        rpi-sign-bootcode = (pkgs.callPackage ./pkgs/rpi-sign-bootcode/package.nix {});
      in {
        packages.default = rpi-sign-bootcode;
        apps.default = flake-utils.lib.mkApp {drv = rpi-sign-bootcode;};
      }
    );
}