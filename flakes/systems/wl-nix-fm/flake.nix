{
  inputs = {

    nixpkgs.url           =  "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url  =  "github:nixos/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: let

    flakeTools = import ../../../lib/flake {};

  in {
    nixosConfigurations = {
      # === wl-nix-fm ===
      
      "wl-nix-fm" = flakeTools.mkNixosConf {
        hostname = "wl-nix-fm";
        system = "x86_64-linux";
        nixpkgs = {
          stable = nixpkgs;
          unstable = nixpkgs-unstable;
        };
        modules = [ ./src/configuration.nix ];
        specialArgs = { inherit inputs; };
      };
      
      # === hd-nix-fm ===
    };
  };
}