{
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.dev;

  # Create args for child-modules
  childArgs = args // { inherit configRelative; };

  # Import child-modules
  git  =  (import ./git childArgs);
in
{
  # === Options ===
  options = {
    git  =  git.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs git [ "options" ])
  ];
  # === Imports ===
}