{
  configRoot,
  configRootToRelative,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  cfg = configRootToRelative configRoot;

  pkg = pkgs.git;
in
{
  # === Options ===
  options = {
    "enable" = lib.mkOption {
      description = "Whether to enable `git`.";
      default = false;
      type = lib.types.bool;
    };
  };
  # === Options ===


  # === Config ===
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkg;

      userName = "Milner39";
      userEmail = "91906877+Milner39@users.noreply.github.com";

      extraConfig = {
        init.defaultBranch = "mains";

        safe.directory = [ "/etc/nixos" ];
      };
    };
  };
  # === Config ===
}