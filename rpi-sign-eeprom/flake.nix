{
  description = "Flake to fetch and sign Raspberry Pi bootfiles.bin using rpi-sign-bootcode";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" ];
      pkgsFor = system: import nixpkgs { inherit system; };
    in
    {
      packages = builtins.listToAttrs (map (system: let
        pkgs = pkgsFor system;
      in {
        name = system;
        value = pkgs.stdenv.mkDerivation {
          pname = "sign-bootfiles";
          version = "0.1";

          buildInputs = [ pkgs.curl pkgs.bash pkgs.openssl pkgs.coreutils pkgs.gnumake ];

          unpackPhase = "";

          buildPhase = ''
            mkdir -p $out/bin
            cat > $out/bin/sign-bootfiles <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
if [ "$#" -lt 2 ]; then
  cat <<USAGE >&2
Usage: sign-bootfiles <private-key.pem> <signed-output.bin> [firmware-version]

This script will download the example `bootfiles.bin` and the
`rpi-sign-bootcode` helper from the Raspberry Pi usbboot example repo,
then run the signing operation. Provide your private key as the first
argument. The signed artifact path is the second argument.
USAGE
  exit 2
fi

KEY="$1"
OUT="$2"
FWVER="${3:-0}"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

echo "Downloading bootfiles.bin..."
curl -fsSL -o "$WORKDIR/bootfiles.bin" \
  https://raw.githubusercontent.com/raspberrypi/usbboot/master/secure-boot-example/bootfiles.bin

echo "Downloading rpi-sign-bootcode..."
curl -fsSL -o "$WORKDIR/rpi-sign-bootcode" \
  https://raw.githubusercontent.com/raspberrypi/usbboot/master/secure-boot-example/rpi-sign-bootcode
chmod +x "$WORKDIR/rpi-sign-bootcode"

echo "Signing..."
"$WORKDIR/rpi-sign-bootcode" "$WORKDIR/bootfiles.bin" "$KEY" "$OUT" "$FWVER"

echo "Signed output: $OUT"
EOF

            chmod +x $out/bin/sign-bootfiles
          '';

          installPhase = ''
            :
          '';

          meta = with pkgs.lib; {
            description = "Tooling to fetch and sign Raspberry Pi bootfiles.bin";
            license = licenses.mit;
            platforms = platforms.unix;
          };
        };
      }) systems);
    };
}
