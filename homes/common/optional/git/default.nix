{
  config,
  pkgs,
  ...
} @ args:

{
  # Enable Git
  programs.git = {
    enable = true;
    package = pkgs.git;

    userName = "Milner39";
    userEmail = "91906877+Milner39@users.noreply.github.com";

    extraConfig = {
      init.defaultBranch = "main";

      safe.directory = [ "/etc/nixos" ];
    };
  };
}