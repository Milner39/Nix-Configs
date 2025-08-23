{
  configRoot,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.nerd-fonts;
  cfg = configRelative;
in
{
  # === Options ===
  options = {
    "all" = lib.mkOption {
      description = "Whether to install all fonts from NerdFonts.";
      default = false;
      type = lib.types.bool;
    };

    "fonts" = lib.mkOption {
      description = "Specific fonts to install from NerdFonts.";
      default = [];
      # type = lib.types.;
    };
  };
  # === Options ===


  # === Config ===
  config = {

    # Install all fonts from NerdFonts
    home.packages = lib.mkIf cfg.all (
      builtins.filter
        (lib.attrsets.isDerivation)
        (builtins.attrValues pkgs.nerd-fonts)
    );

  };
  # === Config ===
}

# TODO: allow option for declaring specific fonts from NerdFonts to install