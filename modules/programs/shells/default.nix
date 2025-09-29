{
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.shells;

  # Create args for child-modules
  childArgs = args // { inherit configRelative; };

  # Import child-modules
  bash  =  (import ./bash childArgs);
  zsh   =  (import ./zsh  childArgs);
  ui    =  (import ./ui   childArgs);
in
{
  # === Options ===
  options = {
    bash  =  bash.options;
    zsh   =  zsh.options;
    ui    =  ui.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs bash [ "options" ])
    (builtins.removeAttrs zsh  [ "options" ])
    (builtins.removeAttrs ui   [ "options" ])
  ];
  # === Imports ===
}