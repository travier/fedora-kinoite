# Custom Fedora Kinoite images

This repository hosts Containerfiles and GitHub workflows to create custom
Fedora Kinoite images for my own usage.

The main image (`fedora-kinoite`, pushed to
`quay.io/travier/fedora-kinoite:latest`) is based on Fedora Kinoite Bootable
Container images with the following changes:

- [xpadneo](https://atar-axis.github.io/xpadneo/) out of tree kernel module for
  Xbox Wireless Controller support. The kmod are packaged by
  [negativo17](https://negativo17.org) and signed with a MOK user key (public
  key included in the image).
- Default `/etc/containers/policy.json` config to setup signature verification
  for those images and other containers from my namespace on
  [quay.io](https://quay.io/user/travier/).
- `openh264` and `mozilla-openh264` installed by default.
- `steam-devices` installed by default but Steam Input support.
- SetUID bit removed from selected binaires.

This images used to include other packages, that I have now moved to
[systemd system extensions](https://github.com/travier/fedora-sysexts) instead.

The others images are currently used for testing various in progress changes
for Fedora Kinoite.

## How to use

- Install Fedora Kinoite, update to the latest version and reboot.

- Setup the key to validate container image signatures:

```
# Install public key
$ sudo mkdir /etc/pki/containers
$ curl -O "https://raw.githubusercontent.com/travier/fedora-kinoite/main/quay.io-travier-fedora-kinoite.pub"
$ sudo cp quay.io-travier-fedora-kinoite.pub /etc/pki/containers/
$ sudo restorecon -RFv /etc/pki/containers

# Configure registry to get sigstore signatures
$ cat /etc/containers/registries.d/quay.io-travier-fedora-kinoite.yaml
docker:
  quay.io/travier/fedora-kinoite:
    use-sigstore-attachments: true
$ sudo restorecon -RFv /etc/containers/registries.d/quay.io-travier-fedora-kinoite.yaml

# Setup the policy
$ sudo cp etc/containers/policy.json /etc/containers/policy.json
$ cat /etc/containers/policy.json
{
    "default": [
        {
            "type": "reject"
        }
    ],
    "transports": {
        "docker": {
            ...
            "quay.io/travier/fedora-kinoite": [
                {
                    "type": "sigstoreSigned",
                    "keyPath": "/etc/pki/containers/quay.io-travier-fedora-kinoite.pub",
                    "signedIdentity": {
                        "type": "matchRepository"
                    }
                }
            ],
            ...
            "": [
                {
                    "type": "insecureAcceptAnything"
                }
            ]
        },
        ...
    }
}
```

- Then rebase to this image:

```
$ rpm-ostree rebase ostree-image-signed:registry:quay.io/travier/fedora-kinoite:latest
```

Then update normally using `rpm-ostree update` or Discover.

## Important notes

- The base images are not yet official Fedora images. The location will change.
- The images are only available for `x86_64` for now.

## License

See [LICENSE](LICENSE) or [CC0](https://creativecommons.org/public-domain/cc0/).
