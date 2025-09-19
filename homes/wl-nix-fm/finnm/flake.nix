{
  inputs = {
    # === Essentials ===

    nixpkgs.url           =  "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url  =  "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # === Essentials ===

  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let

    flakeTools = import ../../../lib/flake {};

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
      # === finnm@wl-nix-fm ===

      "finnm@wl-nix-fm" = flakeTools.mkHomeConf {
        username = "finnm";
        system = "x86_64-linux";
        home-manager = home-manager;
        nixpkgs = {
          stable = nixpkgs;
          unstable = nixpkgs-unstable;
        };
        modules = [ ./src/home.nix ];
        extraSpecialArgs = { inherit inputs; };
      };

      # === finnm@wl-nix-fm ===
    };
  };
}
