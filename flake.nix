{
  inputs = {
    # === Essentials ===

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # === Essentials ===

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let

    # Extend lib with lib.custom
    lib = nixpkgs.lib.extend (self: super: {
      custom = {};  # import ./lib { inherit (nixpkgs) lib; };
    });

    baseSpecialArgs = { inherit
      inputs
      lib;
    };

  in {
    homeConfigurations = {
      # === finnm@FM-PC-NIXOS ===

      "finnm@FM-PC-NIXOS" = let
        username = "finnm";

        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        extraSpecialArgs = baseSpecialArgs // { inherit
          username;
        };

      in home-manager.lib.homeManagerConfiguration {
        inherit system pkgs extraSpecialArgs;

        modules = [
          {
            home = {
              username = username;
              homeDirectory = "/home/${username}";
            };
          }

          ./homes/FM-PC-NIXOS/finnm/home.nix
        ];
      };

      # === finnm@FM-PC-NIXOS ===
    };
  };
}
