{
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.terminals;

  # Create args for child-modules
  childArgs = args // { inherit configRelative; };

  # Import child-modules
  # shells        =  (import ./shells       childArgs);
  # terminals     =  (import ./terminals    childArgs);
  # text-editors  =  (import ./text-editors childArgs);
in
{
  # === Options ===
  # options = {
  #   shells        =  shells.options;
  #   terminals     =  terminals.options;
  #   text-editors  =  text-editors.options;
  # };
  # === Options ===


  # === Imports ===
  imports = [
    # (builtins.removeAttrs shells       [ "options" ])
    # (builtins.removeAttrs terminals    [ "options" ])
    # (builtins.removeAttrs text-editors [ "options" ])
  ];
  # === Imports ===
}