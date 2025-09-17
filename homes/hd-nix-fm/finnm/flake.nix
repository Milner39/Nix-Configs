{
  inputs = {
    # === Essentials ===

    nixpkgs.url           =  "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url  =  "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
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
    # home-manager switch --flake ./hosts/hd-nix-fm/finnm
    homeConfigurations = {
      # === finnm@hd-nix-fm ===

      "finnm@hd-nix-fm" = flakeTools.mkHomeConf {
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

      # === finnm@hd-nix-fm ===
    };
  };
}
