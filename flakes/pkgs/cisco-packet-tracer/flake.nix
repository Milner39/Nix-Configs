{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... } @ inputs: let
    systems = [ "x86_64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

    pkg-name = "cisco-packet-tracer";
    CPT-deb = ./CiscoPacketTracer.deb;

  in {
    packages = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Extract `.deb` at build time
        extracted = pkgs.runCommand "${pkg-name}-extracted" {} ''
          mkdir $out
          dpkg-deb -x ${CPT-deb} $out/
        '';
      in {
        "${pkg-name}" = pkgs.buildFHSUserEnv {
          name = pkg-name;

          # Packages to be available in FHS environment
          targetPkgs = pkgs: [
            pkgs.stdenv.cc
            pkgs.zlib
            pkgs.freetype
            pkgs.fontconfig
            pkgs.gtk3
            pkgs.glibc
            pkgs.libglvnd
            pkgs.qt5.full
            pkgs.libpulseaudio
            pkgs.openssl
          ];

          # Maps extracted packages to correct location in FHS environment
          extraMounts = [
            { source = "${extracted}/opt"; target = "/opt"; }
          ];

          # The command to run
          runScript = "${extracted}/opt/pt/bin/PacketTracer";
        };
      });
  };
}