{
  description = "Minimal NixOS VM flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.minimal = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ({ pkgs, ... }: {

          system.stateVersion = "25.11";

          boot.loader.grub.enable = false;
          boot.loader.systemd-boot.enable = false;

          services.getty.autologinUser = "root";

          users.users.root.initialPassword = "root";

          environment.systemPackages = with pkgs; [
            vim
            git
          ];
        })
      ];
    };
  };
}
