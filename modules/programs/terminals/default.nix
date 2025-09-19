{
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.terminals;

  # Create args for child-modules
  childArgs = args // { inherit configRelative; };

  # Import child-modules
  ghostty  =  (import ./ghostty childArgs);
in
{
  # === Options ===
  options = {
    ghostty  =  ghostty.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs ghostty [ "options" ])
  ];
  # === Imports ===
}