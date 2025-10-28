{
  moduleConfig,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get module configuration
  cfg = moduleConfig;

  pkg = pkgs.ghostty;
in
{
  # === Options ===
  options = {
    "enable" = lib.mkOption {
      description = "Whether to enable `ghostty`.";
      default = false;
      type = lib.types.bool;
    };

    "preferred" = lib.mkOption {
      description = "Whether to set `$TERMINAL` to this terminal.";
      default = false;
      type = lib.types.bool;
    };
  };
  # === Options ===


  # === Config ===
  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      package = pkg;
    };
  };
  # === Config ===


  # === Imports ===
  imports = [
    (import ../set-preferred-term.nix {
      inherit lib;
      enable = cfg.preferred;
      package = pkg;
      binaryPath = "/bin/ghostty";
    })
  ];
  # === Imports ===
}