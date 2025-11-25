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

    pname = "cisco-packet-tracer";
    version = "1.0.0";
    CPT-deb = inputs.cisco-packet-tracer-deb;

  in {
    packages = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Unpack the `.deb`
        CPT-deb-unpacked = pkgs.stdenv.mkDerivation {
          pname = "${pname}-deb-unpacked";
          version = version;

          src = CPT-deb;
          nativeBuildInputs = [ pkgs.dpkg ];

          unpackPhase = ''
            mkdir -p $out
            dpkg-deb -x $src $out
          '';
        };

        # Extract `AppImage`
        CPT-app-dir = pkgs.appimageTools.extractType2 {
          pname = "${pname}-app-image";
          version = version;
          src = "${CPT-deb-unpacked}/opt/pt/packettracer.AppImage";
        };

      in {
        "${pname}" = pkgs.stdenv.mkDerivation {
          pname = pname;
          version = version;

          nativeBuildInputs = with pkgs; [
            autoPatchelfHook
          ];
          dontWrapQtApps = true;

          buildInputs = with pkgs; [
            zlib
            libpng
            libxkbfile
            freetype
            fontconfig
            nss
            nspr
            alsa-lib
            xorg.libXext
            xorg.libX11
            xorg.libXrender
            xorg.libXi
            xorg.libXtst
            xorg.libXrandr
            libdrm
            wayland

            xz
            qt6.qttools
            pulseaudio
            xorg.libXdamage
            mtdev
            tslib
            libinput
          ];

          src = CPT-app-dir;

          installPhase = ''
            mkdir -p $out/opt/pt
            cp -r . $out/opt/pt/

            mkdir -p $out/bin
            cat > $out/bin/${pname} <<EOF
            #!${pkgs.bash}/bin/bash
            exec $out/opt/pt/AppRun "\$@"
            EOF
            chmod +x $out/bin/${pname}
          '';
        };
      });
  };
}