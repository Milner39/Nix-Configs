{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
  
    homeConfigurations = {
      default = let
        username = "FinnM";

        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};

        extraSpecialArgs = { inherit
          username
          inputs;
        };
      in home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;

        modules = [
          ./homes/default/home.nix
        ];
      };
    };
  };
}