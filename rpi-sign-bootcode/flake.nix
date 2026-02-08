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
        python = pkgs.python313;
        pythonDeps = python.withPackages(pipPackage: with pipPackage;[
          pycryptodomex
        ]);
        packageVersion = "2025.12.08-2712";

        rpi-sign-bootcode=with pkgs; stdenv.mkDerivation {
          pname = "rpi-sign-bootcode";
          version = packageVersion;
          src = pkgs.fetchFromGitHub {
            owner = "raspberrypi";
            repo = "rpi-eeprom";
            tag = "v${packageVersion}";
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
        packages.default = rpi-sign-bootcode;
        apps.default = flake-utils.lib.mkApp {drv = rpi-sign-bootcode;};
      }
    );
}