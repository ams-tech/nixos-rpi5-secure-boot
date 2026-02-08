{
  description = "Utility for signing the RPi";

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
        python = pkgs.python313;
        pythonDeps = python.withPackages(ps: with ps;[
          pycryptodomex
        ]);
        derivationToBeRenamed=with pkgs; stdenv.mkDerivation {
          pname = "rpi-sign-bootcode";
          name = "my-package";  # Add the 'name' attribute
          src = pkgs.fetchFromGitHub {
            owner = "raspberrypi";
            repo = "rpi-eeprom";
            tag = "v2025.12.08-2712";
            hash = "sha256-6zlq6BibjPWSGQPl13vFNCPVzjnROfYowVYPttQ9jZQ=";
            fetchSubmodules = true;
          };
          buildInputs = [pythonDeps];
          installPhase = ''
            mkdir -p $out/bin
            cp $src/tools/rpi-sign-bootcode $out/bin
            '';
        };
      in {
        packages.default = derivationToBeRenamed;
        apps.default = flake-utils.lib.mkApp {drv =derivationToBeRenamed;};
      });

    
}