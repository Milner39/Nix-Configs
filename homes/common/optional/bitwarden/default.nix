{
  config,
  pkgs,
  ...
} @ args:

{
  home.packages = with pkgs; [
    # Add Bitwarden
    pkgs.bitwarden-desktop

    # Add a script to use Bitwarden SSH socket
    (pkgs.writeShellScriptBin "ssh-bw" (builtins.readFile ./ssh-bw.sh))
  ];

  # TODO: Conditionally set git config `sshCommand` to use Bitwarden SSH
  # So far: just do it without checking if the user wants to
  programs.git.extraConfig.core.sshCommand = "ssh-bw";
}