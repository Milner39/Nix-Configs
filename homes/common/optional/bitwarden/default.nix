{
  config,
  pkgs,
  ...
} @ args:

{
  home.packages = with pkgs; [
    # Add Bitwarden
    pkgs.bitwarden

    # Add a script to use Bitwarden SSH socket
    (pkgs.writeShellScriptBin "ssh-bw" (builtins.readFile ./ssh-bw.sh))
  ];

  # TODO: Conditionally set git config sshCommand
}