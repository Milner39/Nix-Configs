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

    # Extend lib with Home Manager & lib.custom
    lib = nixpkgs.lib.extend (self: super: {
      hm = home-manager.lib.hm;
      custom = import ./lib { inherit (nixpkgs) lib; };
    });

    baseSpecialArgs = { inherit
      inputs
      lib;
    };

  in {
    homeConfigurations = {
      # === finnm@hd-nix-fm ===

      "finnm@hd-nix-fm" = let
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
        inherit pkgs extraSpecialArgs;

        modules = [
          {
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
            };
          }

          ./homes/hd-nix-fm/finnm/home.nix
        ];
      };

      # === finnm@hd-nix-fm ===
    };
  };
}
