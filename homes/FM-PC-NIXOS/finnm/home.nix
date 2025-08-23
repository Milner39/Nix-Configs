{
  config,
  lib,
  pkgs,

  # extraSpecialArgs
  username,
  ...
} @ baseArgs:

let
  # Extend args with ...
  args = baseArgs; # // {};
in
{
  imports = [
    # Add modules
    (import (lib.custom.fromRoot "homes/common/optional/bitwarden") args)
    (import (lib.custom.fromRoot "homes/common/optional/ghostty") args)
    (import (lib.custom.fromRoot "homes/common/optional/git") args)
    (import (lib.custom.fromRoot "homes/common/optional/zsh") args)
  ];



  # === Home Manager ===

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # === Home Manager ===


  # === User Environment ===

  # Packages
  home.packages = with pkgs; [

  ];

  fonts.packages = [
    # Install all fonts from NerdFonts
    (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts))

    # Install specific fonts from NerdFonts
    # nerd-fonts.jetbrains-mono
  ];

  # Programs
  programs = {
    bash.enable = true;
  };

  # Variables
  home.sessionVariables = {
    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/finnm/etc/profile.d/hm-session-vars.sh

  };

  # === User Environment ===


  # === Dotfiles ===

  home.file = {
  };

  # === Dotfiles ===
}