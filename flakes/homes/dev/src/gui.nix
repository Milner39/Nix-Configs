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
} @ baseArgs:

let
  # Extend args with ...
  args = baseArgs; # // {};
in
{
  modules.gui = {
    window-manager.hyprland.enable = true;
    app-launcher.rofi.enable = true;
  };
}