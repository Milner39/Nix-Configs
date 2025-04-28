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
  } @ inputs: let

    # Declare system architecture
    system = "x86_64-linux";

    # Import packages
    pkgs = nixpkgs.legacyPackages.${system};

    # Additional HomeManager inputs
    extraSpecialArgs = { inherit inputs; };

  in {
    homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
      inherit pkgs extraSpecialArgs;

      modules = [
        ./homes/default/home.nix
      ];
    };
  };
}