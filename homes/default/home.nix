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
    with pkgs; [
      neovim
    ]
  );

  # === Environment ===



  # === HomeManager ===

  home.username = builtins.getEnv "USER";
  home.homeDirectory = "/home/${builtins.getEnv "USER"}";
  home.stateVersion = "24.11";

  # === HomeManager ===
}