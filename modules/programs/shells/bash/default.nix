{
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.bash;
  cfg = configRelative;

  bash-pkg = pkgs.bash;
in
{
  # === Options ===
  options = {
    "enable" = lib.mkOption {
      description = "Whether to enable `bash`.";
      default = false;
      type = lib.types.bool;
    };

    "preferred" = lib.mkOption {
      description = "Whether to set `$SHELL` to this shell.";
      default = false;
      type = lib.types.bool;
    };
  };
  # === Options ===


  # === Config ===
  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      package = bash-pkg;
    };
  };
  # === Config ===


  # === Imports ===
  imports = lib.mkIf cfg.preferred [
    (import ../set-preferred-shell.nix {
      shellPackage = bash-pkg;
      binaryPath = "/bin/bash";
    })
  ];
  # === Imports ===
}