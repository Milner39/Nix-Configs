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
    menu.rofi.enable = true;
  };
}