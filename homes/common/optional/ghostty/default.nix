{
  config,
  pkgs,
  ...
} @ args:

{
  # Enable Ghostty
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;

    # Bypass forced NixOS $SHELL
    # settings = {
    #   command = "${config.home.sessionVariables.SHELL} --login --interactive";
    # };
  };
}