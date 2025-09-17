{
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.zsh;
  cfg = configRelative;

  zsh-pkg = pkgs.zsh;
in
{
  # === Options ===
  options = {
    "enable" = lib.mkOption {
      description = "Whether to enable `zsh`.";
      default = false;
      type = lib.types.bool;
    };

    "preferred" = lib.mkOption {
      description = "Whether to set `$SHELL` to this shell.";
      default = false;
      type = lib.types.bool;
    };
  };
  # === Options ===


  # === Config ===
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      package = zsh-pkg;
    };
  };
  # === Config ===


  # === Imports ===
  imports = [
    (import ../set-preferred-shell.nix {
        inherit lib;
        enable = cfg.preferred;
        shellPackage = zsh-pkg;
        binaryPath = "/bin/zsh";
      }
    )
  ];
  # === Imports ===
}