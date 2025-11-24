{
  config,
  lib,
  pkgs,
  pkgs-unstable,

  # extraSpecialArgs
  system,
  username,
  inputs,
  ...
} @ baseArgs:

let
  # Extend args
  args = baseArgs // {
  };
in
{
  imports = [
    # Import modules that can be configured under the `modules` option.
    # This is a special function that recursively builds a "tree" of options 
    # based on the directory structure of choice.
    # https://github.com/Milner39/nix-utils
    (inputs.my-utils.lib.${system}.mkOptionTreeFromDir {
      configRoot = config;
      optionTreeName = "modules";
      modulesDir = lib.custom.fromRoot "modules/home-manager";
      specialArgs = args;
    })

    (import ./gui.nix args)
  ];



  # === Home Manager ===

  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };

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




  # Packages
  home.packages = with pkgs; [
    ranger

    liberation_ttf

    obsidian
    pkgs-unstable.ncspot
  ];


  # Shells
  modules.programs.shells = {
    zsh = {
      enable = true;
      preferred = true;  # Sets `$SHELL`
    };
    bash.enable = true;

    ui.oh-my-posh.enable = true;
  };


  # Terminals
  modules.programs.terminals = {
    ghostty = {
      enable = true;
      preferred = true;  # Sets `$TERMINAL`
    };
  };


  # Text Editors
  modules.programs.text-editors = {
    vscode = {
      enable = true;
      preferred = true;  # Sets `$EDITOR`
    };
  };


  # Dev Tools
  modules.programs.dev.git.enable = true;


  # Fonts
  modules.fonts.nerd-fonts = {
    # all = true;  # For all NerdFonts
    fonts = nf: with nf; [
      jetbrains-mono
    ];
  };
}