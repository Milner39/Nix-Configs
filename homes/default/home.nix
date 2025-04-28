{
  pkgs,
  ...
} @ args:

let
  common = import ../common;
in
{
  # === Environment ===

  home.packages = common.withDefaultPackages { inherit pkgs; } (
    with pkgs [
      neovim
    ];
  );

  # === Environment ===



  # === HomeManager ===

  home.stateVersion = "24.11";

  # === HomeManager ===
}