{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    cisco-packet-tracer-deb = {
      url = "path:./CiscoPacketTracer.deb";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs: let
    systems = [ "x86_64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

    pkg-name = "cisco-packet-tracer";
    CPT-deb = inputs.cisco-packet-tracer-deb;

  in {
    packages = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Unpack the `.deb`
        CPT-deb-unpacked = pkgs.stdenv.mkDerivation {
          name = "${pkg-name}-deb-unpacked";
          src = CPT-deb;
          nativeBuildInputs = [ pkgs.dpkg ];

          unpackPhase = ''
            mkdir -p $out
            dpkg-deb -x $src $out
          '';
        };

        # Extract `AppImage`
        CPT-app-dir = pkgs.appimageTools.extractType2 {
          pname = pkg-name;
          version = "1.0.0";
          src = "${CPT-deb-unpacked}/opt/pt/packettracer.AppImage";
        };

      in {
        "${pkg-name}" = pkgs.buildFHSEnv {
          name = pkg-name;

          targetPkgs = pkgs: with pkgs; [
            zlib
            openssl
            fontconfig
            freetype
            libglvnd
            libpulseaudio
            qt5.qtwayland
            qt5.qtbase
            qt5.qtsvg
            qt5.qtdeclarative
            glibc
          ];

          runScript = "${CPT-app-dir}/AppRun";

          extraMounts = [{
            source = CPT-app-dir;
            target = "/opt/pt";
          }];
        };
      });
  };
}