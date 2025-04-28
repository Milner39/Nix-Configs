{
  pkgs,

  # extraSpecialArgs
  username,
  ...
} @ args:

let
  common = import ../common;
in
{
  # === Environment ===

  home.packages = common.withDefaultPackages { inherit pkgs; } (
    with pkgs; [

    ]
  );

  home.shell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
  };

  programs.neovim = {
    enable = true;
  };

  # === Environment ===



  # === HomeManager ===

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  # === HomeManager ===
}