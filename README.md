# Custom Fedora Kinoite image with overlayed packages

This is an image of Fedora Kinoite with the following packages overlayed:

- libvirtd (libvirt-daemon libvirt-daemon-config-network
  libvirt-daemon-driver-interface libvirt-daemon-driver-network
  libvirt-daemon-driver-nwfilter libvirt-daemon-driver-qemu
  libvirt-daemon-driver-secret libvirt-daemon-driver-storage-core libvirt-dbus
  qemu-kvm)
- iwd (a better wifi daemon than `wpa_supplicant`)
- sysprof
- vim, zsh, htop, distrobox

## How to use

- Install Fedora Kinoite, update to the latest version and reboot.

- Setup the key to validate container image signatures:

```
# Install public key
$ sudo mkdir /etc/pki/containers
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

Then update normally using `rpm-ostree update` or Discover (pending
[rpm-ostree: Fix ostree container support](https://invent.kde.org/plasma/discover/-/merge_requests/591)).

## Important notes

- The base images are not yet official Fedora images. The location will change.
- The images are only available for x86_64 for now.
