{
  pkgs,
  ...
} @ args:

{
  # Default packages
  home.packages = with pkgs; [
    # Version control
    git

    # Secrets
    sops
    ssh-to-age

    # Home environment
    home-manager
  ];
}