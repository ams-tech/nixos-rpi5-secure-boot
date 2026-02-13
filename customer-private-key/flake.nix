{
  description = "nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    # optional, not necessary for the module
    #inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

      nixosConfigurations = {
        your-hostname = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./configuration.nix ];
        };
      };

    };
}