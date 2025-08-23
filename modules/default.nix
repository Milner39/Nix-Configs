{
  config,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  configRelative = config.modules;

  # Create args for child-modules
  childArgs = {
    configRoot = config;
    inherit configRelative lib pkgs;
  };

  # Import child-modules
  fonts = (import ./fonts childArgs);
in
{
  # === Options ===
  options.modules = {
    fonts = fonts.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs fonts [ "options" ])
  ];
  # === Imports ===
}