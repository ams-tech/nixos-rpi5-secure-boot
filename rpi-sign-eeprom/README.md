# sign-bootfiles flake

This flake provides a small helper package `sign-bootfiles` that downloads
the example `bootfiles.bin` and `rpi-sign-bootcode` helper from the
Raspberry Pi `usbboot` repository and runs the signing operation.

Quick usage (after building or using the package in a dev shell):

1. Provide your private key file (PEM) and an output path for the signed blob.

Example:

```bash
nix run .#sign-bootfiles -- /path/to/customer-key.pem signed-bootfiles.bin 0
```

Notes:
- This script downloads assets at runtime; verify URLs and contents before use.
- Protect your private key; do not commit it to version control.
