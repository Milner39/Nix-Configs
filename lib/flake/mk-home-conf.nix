opts:

let
  # === Module ===

  module = { lib, ... }: {
    /*
      Defines the types of the `opts` argument for easier docs, setting
      required options or default values, etc.
    */
    options = {
      "username" = lib.mkOption {
        description = "The user's username";
        default = "user";
        type = lib.types.str;
      };

      "system" = lib.mkOption {
        description = ''
          The architecture and platform of the machine.

          See supported options:
          https://github.com/NixOS/nixpkgs/blob/master/lib/systems/flake-systems.nix
        '';
        default = null;  # required
        type = lib.types.str;
      };

      "home-manager" = lib.mkOption {
        description = "The flake input of Home Manger.";
        default = null;  # required
        type = lib.types.raw;
      };

      "nixpkgs" = lib.mkOption {
        description = "Set nixpkgs versions to use.";
        default = null;
        type = lib.types.submodule {
          options = {
            "allowUnfree" = lib.mkOption {
              description = "Whether to include packages whose licenses are marked unfree.";
              default = true;
              type = lib.types.bool;
            };

            "stable" = lib.mkOption {
              description = "The flake input for nixpkgs: to use when 'stable' pkgs are preferred.";
              default = null;  # required
              type = lib.types.raw;
            };

            "unstable" = lib.mkOption {
              description = "The flake input for nixpkgs: to use when 'unstable' pkgs are preferred.";
              type = lib.types.raw;
            };
          };
        };
      };

      "modules" = lib.mkOption {
        description = "A list of Home Manager modules to include in the system evaluation.";
        default = [];
        type = lib.types.listOf lib.types.raw;
      };

      "extraSpecialArgs" = lib.mkOption {
        description = ''
          An attribute set whose contents are made available as additional 
          arguments to the top-level function of every Home Manager module.
        '';
        default = {};
        type = lib.types.attrsOf lib.types.raw;
      };
    };
  };

  # === Module ===



  # === Lib ===

  lib-base = opts.nixpkgs.stable.lib;

  # === Lib ===



  # === Evaluation ===

  /*
    Evaluate the `opts` argument
    Evaluate the `module`
  */
  evaled = (lib-base.evalModules {
    modules = [ opts module ];
  }).config;


  # Create the home-manager config
  homeManagerConfig = let

    # == Pkgs ===
    system            =  evaled.system;

    allowUnfree       =  evaled.nixpkgs.allowUnfree;
    nixpkgs           =  evaled.nixpkgs.stable;
    nixpkgs-unstable  =  evaled.nixpkgs.unstable or evaled.nixpkgs.stable;
    # Fallback to stable packages if unstable packages not provided ^

    pkgs              =  import nixpkgs {
      inherit system; config.allowUnfree = allowUnfree;
    };
    pkgs-unstable     =  import nixpkgs-unstable {
      inherit system; config.allowUnfree = allowUnfree;
    };


    home-manager      = evaled.home-manager;
    # == Pkgs ===

    username = evaled.username;
    modules = evaled.modules;

    # Extend lib with Home Manager & lib.custom
    lib-custom = pkgs.lib.extend (self: super: {
      hm = home-manager.lib.hm;
      custom = import ../../lib { inherit (pkgs) lib; };
    });

    extraSpecialArgs = evaled.extraSpecialArgs // {
      inherit pkgs-unstable username;
      lib = lib-custom;
    };

  in home-manager.lib.homeManagerConfiguration { inherit
    pkgs
    modules
    extraSpecialArgs;
  };

  # === Evaluation ===

in homeManagerConfig