{
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.oh-my-posh;
  cfg = configRelative;

  pkg = pkgs.oh-my-posh;
in
{
  # === Options ===
  options = {
    "enable" = lib.mkOption {
      description = "Whether to enable `oh-my-posh`.";
      default = false;
      type = lib.types.bool;
    };
  };
  # === Options ===


  # === Config ===
  config = lib.mkIf cfg.enable {
    programs.oh-my-posh = {
      enable = true;
      package = pkg;

      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
  };
  # === Config ===
}