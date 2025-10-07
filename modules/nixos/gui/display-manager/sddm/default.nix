{
  moduleConfig,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get module configuration
  cfg = moduleConfig;

  pkg = pkgs.plasma5Packages.sddm;
in
{
  # === Options ===
  options = {
    "enable" = lib.mkOption {
      description = "Whether to enable `sddm`.";
      default = false;
      type = lib.types.bool;
    };
  };
  # === Options ===


  # === Config ===
  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      package = pkg;

      # Enable support for Wayland (Doesn't mean Wayland must be used)
      wayland.enable = true;
    };
  };
  # === Config ===
}