{
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.programs;

  # Create args for child-modules
  childArgs = args // { inherit configRelative; };

  # Import child-modules
  dev           =  (import ./dev          childArgs);
  shells        =  (import ./shells       childArgs);
  terminals     =  (import ./terminals    childArgs);
  text-editors  =  (import ./text-editors childArgs);
in
{
  # === Options ===
  options = {
    dev           =  dev.options;
    shells        =  shells.options;
    terminals     =  terminals.options;
    text-editors  =  text-editors.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs dev          [ "options" ])
    (builtins.removeAttrs shells       [ "options" ])
    (builtins.removeAttrs terminals    [ "options" ])
    (builtins.removeAttrs text-editors [ "options" ])
  ];
  # === Imports ===
}