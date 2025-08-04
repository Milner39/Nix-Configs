{
  config,
  pkgs,
  ...
} @ args:

{
  # Enable Z-Shell
  programs.zsh = {
    enable = true;
    package = pkgs.zsh;

  };

  # Some issues with this not being respected
  # Nix wants to keep the default shell the same as the login shell
  home.sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";
}