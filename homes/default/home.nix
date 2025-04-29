{
  pkgs,

  # extraSpecialArgs
  username,
  ...
} @ args:

{
  imports = [
    (import ../common/optional/default-pkgs.nix args)
    (import ../common/optional/yubikey.nix args)
  ];



  # === Environment ===

  home.packages = with pkgs; [

  ];


  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
  };

  programs.neovim = {
    enable = true;
  };

  # === Environment ===



  # === HomeManager ===

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  # === HomeManager ===
}