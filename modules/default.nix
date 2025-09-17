{
  config,
  ...
} @ args:

let
  # Get relative config position
  configRelative = config.modules;

  # Create args for child-modules
  childArgs = args // { inherit configRelative; configRoot = config; };

  # Import child-modules
  fonts     =  (import ./fonts    childArgs);
  programs  =  (import ./programs childArgs);
in
{
  # === Options ===
  options.modules = {
    fonts     =  fonts.options;
    programs  =  programs.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs fonts    [ "options" ])
    (builtins.removeAttrs programs [ "options" ])
  ];
  # === Imports ===
}