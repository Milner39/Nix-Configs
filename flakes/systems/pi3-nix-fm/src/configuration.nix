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

let
  # Extend args
  args = baseArgs // {
    usersData = (import ./users.nix baseArgs);
  };
in
{
  imports = [
    /*
      No `hardware-configuration.nix`: there is nothing to scan on this board.
      `nixos-hardware.nixosModules.raspberry-pi-3` (added in `flake.nix`) covers
      the kernel, initrd modules and wireless firmware, and `fileSystems` come
      from either `./filesystems.nix` or `./sd-image.nix`.
    */

    (inputs.nix-modules.lib.nixosModuleTree {})

    (import ./gui args)
  ];



  # === Nix ===

  nix = {
    settings = {
      trusted-users = args.usersData.trusted-users;

      experimental-features = [ "nix-command" "flakes" ];
      accept-flake-config = true;

      cores = 0;  # Use all
      max-jobs = "auto";

      auto-optimise-store = true;
    };

    # Garbage collection
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  # Nix Helper
  programs.nh = {
    enable = true;
    package = pkgs-unstable.nh;
  };

  system.stateVersion = "26.05";

  # === Nix ===




  # === Build ===

  # Disable building some docs
  documentation = {
    nixos.enable = false;
    man.enable = true;
    info.enable = false;
  };

  # === Build ===


  # === Bootloader ===

  /*
    The bootloader itself is set by the `raspberry-pi-3` profile, which enables
    `boot.loader.generic-extlinux-compatible` and disables GRUB. The GPU
    firmware chainloads U-Boot, which then reads `extlinux.conf`.
  */

  # Old generations keep their kernel + initrd in /boot on the root partition,
  # which adds up fast on an SD card.
  boot.loader.generic-extlinux-compatible.configurationLimit = 10;

  # === Bootloader ===


  # === Kernel ===

  /*
    `raspberry-pi-3` profile sets `lib.mkDefault (linuxPackagesFor linux-rpi)`.

    `linux-rpi` is built from source (vendor defconfig, `raspberrypi/linux`) and
    is in no binary cache, so taking it would mean an emulated aarch64 kernel
    compile on every nixos-hardware bump. Mainline covers the Pi 3 B fine and
    substitutes from cache.nixos.org.

    Drop this line to go back to the vendor kernel.
  */
  boot.kernelPackages = pkgs.linuxPackages;

  # === Kernel ===


  # === Hardware ===

  # For proprietary firmware (fix WiFi cards)
  hardware.enableRedistributableFirmware = true;

  hardware.raspberry-pi.firmware = {
    /*
      Adds an activation script that repopulates the firmware partition on every
      `nixos-rebuild switch`. Off by default. Needs `/boot/firmware` mounted,
      see the mount options in `./filesystems.nix`.
    */
    enable = true;

    /*
      REQUIRED, and off by default.

      `hardware.raspberry-pi.firmware` `mkForce`s
      `sdImage.populateFirmwareCommands`, throwing away the one
      `sd-image-aarch64.nix` provides. Its own install script only copies
      `u-boot.bin`, and only emits `config.txt`'s `kernel=` line, when this is
      enabled.

      Leave it off and the image gets no U-Boot and no `kernel=` line: the GPU
      firmware looks for `kernel8.img`, finds nothing, and the board does not
      boot.
    */
    uboot.enable = true;
  };

  /*
    The profile sets `console=ttyS0,115200n8`, but the Pi 3's mini-UART only
    comes up if the firmware is told to enable it. Without this a failed boot on
    a headless board gives no output.
  */
  hardware.raspberry-pi.configtxt.settings.all.enable_uart = true;

  # === Hardware ===


  # === Memory ===

  # 1GB of RAM, and swapping to an SD card is painful.
  # Compressed swap in RAM is a much better here.
  zramSwap.enable = true;

  # === Memory ===


  # === Networking ===

  networking = {
    hostName = hostname;

    # Enable networking
    networkmanager = {
      enable = true;
      package = pkgs.networkmanager;

      # WiFi options
      wifi = {
        powersave = false;
        backend = "iwd";
      };
    };

    # Onboard WiFi. The `raspberry-pi-3` profile provides the brcmfmac firmware
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # === Networking ===


  # === Security ===

  security.polkit.enable = true;

  # === Security ===


  # === Users ===

  # Gets users options from `usersData.users.<name>.settings`
  users.users = builtins.mapAttrs
    (username: userCfg: userCfg.settings)
    (args.usersData.users);

  # === Users ===


  # === Locale ===

  time.timeZone = "Europe/London";

  i18n = let
    locale = "en_GB.UTF-8";
  in
  {
    defaultLocale = locale;
    extraLocaleSettings = {
      LC_ADDRESS = locale;
      LC_IDENTIFICATION = locale;
      LC_MEASUREMENT = locale;
      LC_MONETARY = locale;
      LC_NAME = locale;
      LC_NUMERIC = locale;
      LC_PAPER = locale;
      LC_TELEPHONE = locale;
      LC_TIME = locale;
    };
  };

  # Configure console keyMap
  console.keyMap = "uk";

  # === Locale ===


  # === Global Environment ===

  # Packages
  environment.systemPackages = with pkgs; [
    # Version control
    git

    # Must haves
    pkgs-unstable.fastfetch
    pkgs-unstable.btop
  ];

  # === Global Environment ===

}
