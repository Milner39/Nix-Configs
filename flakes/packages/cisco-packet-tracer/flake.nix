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
        CPT-unpacked = pkgs.stdenv.mkDerivation {
          name = "${pkg-name}-unpacked";
          src = CPT-deb;
          nativeBuildInputs = [ pkgs.dpkg ];
          unpackPhase = ''
            mkdir -p $out
            dpkg-deb -x $src $out
          '';
        };
      in {
        "${pkg-name}" = pkgs.buildFHSEnv {
          pname = pkg-name;
          version = "1.0.0";

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
          ];

          runScript = "${CPT-unpacked}/opt/pt/packettracer";

          extraOutputsToInstall = [ "dev" "bin" ];

          extraMounts = [{
            source = "${CPT-unpacked}/opt/pt";
            target = "/opt/pt";
          }];
        };
      });
  };
}