# Custom Fedora Kinoite image with overlayed packages

This is an image of Fedora Kinoite with the following packages overlayed:

- libvirtd (libvirt-daemon libvirt-daemon-config-network
  libvirt-daemon-driver-interface libvirt-daemon-driver-network
  libvirt-daemon-driver-nwfilter libvirt-daemon-driver-qemu
  libvirt-daemon-driver-secret libvirt-daemon-driver-storage-core libvirt-dbus
  qemu-kvm)
- iwd (a better wifi daemon than wpa_supplicant)
- sysprof
- vim, zsh, htop, distrobox

## How to use

Install Fedora Kinoite, then rebase to this image:

```
$ rpm-ostree rebase ostree-unverified-image:registry:quay.io/travier/fedora-kinoite:latest
```

Then update normally using `rpm-ostree update` or Discover (pending
[rpm-ostree: Fix ostree container support](https://invent.kde.org/plasma/discover/-/merge_requests/591)).

## To Do

- Add signing using sigstore/cosign.

## Warning notes

- The images are not yet official Fedora images. The location will change.
- The images are only available for x86_64 for now.
- As the images are big, please be frugal with history/storage on quay.io.
