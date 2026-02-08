# customer-private-key

This Flake sets up [sops-nix](https://github.com/Mic92/sops-nix) to manage the signing used by our rpi5 secure boot process.

We're largely following the principles laid out in [this video](https://www.youtube.com/watch?v=G5f6GC7SnhU).  The code blocks used in the video can be found [here](https://github.com/vimjoyer/sops-nix-video).  

## SOPS Quickstart

### Generate a personal keypair

First, we'll generate a keypair that lets `sops-nix` protect our secrets:

Generate the private key using 

`mkdir -p ~/.config/sops/age`

`nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt`

And get the associated public key with

`nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt`

### Make creation rules for our secrets

This is defined in the `.sops.yaml` file.  This is largely boilerplate.

Be sure to replace my public key with your own.

### Create our secrets

Open a new shell wiht sops support:

`nix-shell -p sops`

You can edit this file with your secrets.  Just write some nonsensical values in there for now.

After saving, take a look at the secrets file that was created: `cat secrets/secrets.yaml`.

You'll see every field is encrypted.  You can now save & store this file anywhere, including public git repos, and
you can only recover the secrets with the private key we generated earlier.

