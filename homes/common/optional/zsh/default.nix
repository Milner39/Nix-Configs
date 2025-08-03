{
  pkgs,
  ...
} @ args:

{
  # Enable Z-Shell
  programs.zsh = {
    enable = true;
  };

  # Set $SHELL to Z-Shell
  home.shell = pkgs.zsh;
}