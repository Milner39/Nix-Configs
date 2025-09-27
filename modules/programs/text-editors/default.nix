{
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.text-editors;

  # Create args for child-modules
  childArgs = args // { inherit configRelative; };

  # Import child-modules
  vscode  =  (import ./vscode childArgs);
in
{
  # === Options ===
  options = {
    vscode  =  vscode.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs vscode [ "options" ])
  ];
  # === Imports ===
}