{
  moduleConfig,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get module configuration
  cfg = moduleConfig;

  # Lets me switch everything to `pkgs-unstable` in one change
  pkgs_ = pkgs;
in
{
  # === Options ===
  options = {
    "enable" = lib.mkOption {
      description = "Whether to enable `hyprland`.";
      default = false;
      type = lib.types.bool;
    };
  };
  # === Options ===


  # === Config ===
  config = lib.mkIf cfg.enable {
    # === Hyprland ===

    programs.hyprland = {
      enable = true;
      package = pkgs_.hyprland;
      portalPackage = pkgs_.xdg-desktop-portal-hyprland;

      # Because NixOS uses SystemD so use UWSM for better support
      withUWSM = true;
    };

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [];


    # Include Hyprland's default terminal so default shortcut works
    environment.systemPackages = [ pkgs_.kitty ];

    # === Hyprland ===


    # === Wayland ===
    # Because Hyprland uses Wayland

    # X11 compatibility
    programs.hyprland.xwayland.enable = true;

    # Tell electron apps to use Wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # === Wayland ===


    # === NVIDIA Fixes ===

    # Needed for Wayland
    hardware.nvidia.modesetting.enable = true;

    # Fix mouse flickering
    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

    # === NVIDIA Fixes ===
  };
  # === Config ===
}