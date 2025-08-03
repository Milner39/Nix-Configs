{
  pkgs,
  ...
} @ args:

{
  # Enable Z-Shell
  programs.zsh = {
    enable = true;
  };
}