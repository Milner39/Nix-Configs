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

        CPT = pkgs.stdenv.mkDerivation {
          pname = pname;
          version = version;

          src = CPT-deb;

          nativeBuildInputs = with pkgs; [
            dpkg
            patchelf
            makeWrapper
            libarchive
            squashfsTools
          ];

          unpackPhase = ''
            echo "Unpacking .deb file"
            mkdir deb
            dpkg-deb -x "$src" deb
            echo "Unpacked .deb file"
          '';

          buildPhase = ''
            echo "Finding AppImage"
            appimage="$(find deb -name '*.AppImage' | head -n1)"
            echo "AppImage found: $appimage"

            echo "Locating SquashFS magic offset"
            offset=$(grep -oba 'hsqs' "$appimage" | head -n1 | cut -d: -f1)
            if [ -z "$offset" ]; then
              echo "ERROR: Could not locate SquashFS magic in AppImage"
              exit 1
            fi
            echo "SquashFS starts at byte offset: $offset"

            echo "Extracting SquashFS into a temporary file"
            dd if="$appimage" of=squashfs.img bs=1M skip=$((offset/1048576)) status=progress

            echo "Extracting squashfs.img"
            mkdir appdir
            ${pkgs.squashfsTools}/bin/unsquashfs -d appdir/AppDir squashfs.img
            echo "Extraction complete"
          '';

          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/share/applications
            mkdir -p $out/share/icons/hicolor/256x256/apps

            # Install the extracted AppDir
            cp -r appdir/AppDir $out/packettracer

            # Main executable inside AppDir
            exe="$out/packettracer/AppRun"

            # Wrapper (makes it discoverable in PATH)
            makeWrapper "$exe" "$out/bin/packettracer" \
              --set APPDIR "$out/packettracer"

            # Desktop entry
            cp $out/packettracer/*.desktop $out/share/applications/packettracer.desktop
            substituteInPlace $out/share/applications/packettracer.desktop \
              --replace "/usr/bin/packettracer" "$out/bin/packettracer"

            # Try copying icon (PacketTracer usually ships a PNG)
            icon=$(find $out/packettracer -name '*.png' | head -n1 || true)
            if [ -n "$icon" ]; then
              cp "$icon" $out/share/icons/hicolor/256x256/apps/packettracer.png
            fi
          '';
        };
      in {
        "${pname}" = CPT;
      }
    );
  };
}