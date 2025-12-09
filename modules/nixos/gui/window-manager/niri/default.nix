{
  moduleConfig,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get module configuration
  cfg = moduleConfig;

  pkgs_ = pkgs;
in
{
  # === Options ===
  options = {
    "enable" = lib.mkOption {
      description = "Whether to enable `niri`.";
      default = false;
      type = lib.types.bool;
    };
  };
  # === Options ===


  # === Config ===
  config = lib.mkIf cfg.enable {
    modules.gui.window-manager.compositor.wayland.enable = true;

    # === Niri ===

    environment.systemPackages = with pkgs_; [
      niri
      xwayland-satellite

      # Include Niri's default terminal so default shortcut works
      alacritty
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs_.xdg-desktop-portal-gtk ];
      config.common.default = lib.mkDefault "gtk";
    };

    programs.uwsm.enable = true;
    programs.uwsm.waylandCompositors.niri = {
      prettyName = "Niri";
      comment = "Niri compositor managed by UWSM";
      binPath = lib.getExe (
        pkgs_.writeShellScriptBin "niri-instance" ''
          exec ${lib.getExe pkgs_.niri} --session
        ''
      );
    };

    # === Niri ===
  };
  # === Config ===
}