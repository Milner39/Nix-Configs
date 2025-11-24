{
  inputs = {

    nixpkgs.url           =  "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url  =  "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    my-utils = {
      url = github:Milner39/nix-utils/release-1.0;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cisco-packet-tracer.url = "path:../../pkgs/cisco-packet-tracer";

  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let

    flakeTools = import ../../../lib/flake {};

  in {
    homeConfigurations = {

      default = flakeTools.mkHomeConf {
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

    };
  };
}

/*
  Not using the correct version of Home Manager because 25.05 does not have:
  • `programs.oh-my-posh.configFile` and otherwise, I would not be able to use 
    `.toml` files for configs.
*/