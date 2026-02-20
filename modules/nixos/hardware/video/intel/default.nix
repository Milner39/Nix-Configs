{
  moduleConfig,
  configRoot,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get module configuration
  cfg = moduleConfig;
in
{
  # === Options ===
  options = {
    "enable" = lib.mkOption {
      description = "Whether to enable Intel Linux drivers and custom tweaks.";
      default = false;
      type = lib.types.bool;
    };
  };
  # === Options ===


  # === Config ===
  config = lib.mkIf cfg.enable {

    # Add video driver (DEPRECATED)
    # services.xserver.videoDrivers = [ "intel" ];

    # OpenGL
    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
      ];
      extraPackages32 = with pkgs; [
      ];
    };
  };
  # === Config ===
}
