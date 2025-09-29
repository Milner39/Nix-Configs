{
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.ui;

  # Create args for child-modules
  childArgs = args // { inherit configRelative; };

  # Import child-modules
  oh-my-posh  =  (import ./oh-my-posh childArgs);
in
{
  # === Options ===
  options = {
    oh-my-posh  =  oh-my-posh.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs oh-my-posh [ "options" ])
  ];
  # === Imports ===
}