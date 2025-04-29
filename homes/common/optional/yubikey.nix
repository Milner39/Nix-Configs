{
  pkgs,
  ...
} @ args:

{
  # Packages for managing yubikey
  home.packages = with pkgs; [
    yubikey-manager
    pam_u2f
  ];

  # Allow signing SSH keys with yubikey
  services.yubikey-agent.enable = true;
}