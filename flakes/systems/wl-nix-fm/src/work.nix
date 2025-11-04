{
  config,
  lib,
  pkgs,
  pkgs-unstable,

  # specialArgs
  system,
  hostname,
  inputs,
  ...
} @ baseArgs:

{
  services.samba = {
    enable = true;
    package = pkgs.samba4Full;
  };

  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openconnect
  ];

  environment.systemPackages = with pkgs; [
    samba4Full
    networkmanagerapplet
  ];
}