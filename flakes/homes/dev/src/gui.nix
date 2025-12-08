{
  config,
  lib,
  pkgs,
  pkgs-unstable,

  # extraSpecialArgs
  username,
  system,
  inputs,
  ...
} @ args:

{
  modules.gui = {
    window-manager.hyprland.enable = true;
    window-manager.niri.enable = true;
    menu.rofi.enable = true;
  };
}