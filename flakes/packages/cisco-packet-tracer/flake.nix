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
        appimageTools = pkgs.appimageTools;

        CPT-appimage = pkgs.stdenv.mkDerivation {
          pname = "${pname}-appimage";
          version = version;

          src = CPT-deb;

          nativeBuildInputs = with pkgs; [
            dpkg
          ];

          unpackPhase = ''
            echo "Unpacking .deb file"
            mkdir deb
            dpkg-deb -x "$src" deb
            echo "Unpacked .deb file"
          '';

          buildPhase = "true";

          installPhase = ''
            echo "Finding .AppImage file"
            appimage="$(find deb -name '*.AppImage' | head -n1)"
            if [ -z "$appimage" ]; then
              echo "ERROR: No AppImage found in deb"
              ls -R deb || true
              exit 1
            fi
            echo "Found .AppImage file: $appimage"

            mkdir -p $out
            cp "$appimage" "$out/cisco-packet-tracer.AppImage"
          '';
        };

        CPT = appimageTools.wrapType2 {
          pname = pname;
          version = version;

          src = "${CPT-appimage}/cisco-packet-tracer.AppImage";
          extraPkgs = pkgs: with pkgs; [
            libpng
            xorg.libxkbfile
          ];

          extraInstallCommands = ''
            # Add a desktop entry
            mkdir -p "$out/share/applications"
            cat > "$out/share/applications/cisco-packet-tracer.desktop" <<EOF
            [Desktop Entry]
            Type=Application
            Name=Cisco Packet Tracer
            GenericName=Network Simulator
            Comment=Network simulation tool
            Exec=$out/bin/cisco-packet-tracer
            Icon=cisco-packet-tracer
            Terminal=false
            Categories=Network;Education;
            EOF
          '';
        };
      in {
        "${pname}" = CPT;
      }
    );
  };
}