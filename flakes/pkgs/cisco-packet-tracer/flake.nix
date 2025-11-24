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
      in {
        "${pkg-name}" = pkgs.stdenv.mkDerivation {
          name = pkg-name;

          src = CPT-deb;

          nativeBuildInputs = [
            pkgs.dpkg
            pkgs.patchelf
            pkgs.makeWrapper
          ];

          buildInputs = [
            pkgs.qt5.full
            pkgs.zlib
            pkgs.openssl
            pkgs.freetype
            pkgs.fontconfig
            pkgs.libpulseaudio
            pkgs.libglvnd
            pkgs.glibc
          ];

          unpackPhase = ''
            mkdir deb
            dpkg-deb -x $src deb/
          '';

          installPhase = ''
            mkdir -p $out/opt
            cp -r deb/opt/pt $out/opt/pt

            # Fix interpreter + RPATH for the PacketTracer binary
            patchelf \
              --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
              --set-rpath "$out/opt/pt/lib:${pkgs.qt5.full}/lib:${pkgs.glibc}/lib" \
              $out/opt/pt/bin/PacketTracer

            # Wrap program with QT vars
            mkdir -p $out/bin
            makeWrapper $out/opt/pt/bin/PacketTracer $out/bin/${pkg-name} \
              --prefix QT_PLUGIN_PATH : "$out/opt/pt/plugins" \
              --prefix QT_QPA_PLATFORM_PLUGIN_PATH : "$out/opt/pt/plugins/platforms" \
              --set LD_LIBRARY_PATH "$out/opt/pt/lib"
          '';
        };
      });
  };
}