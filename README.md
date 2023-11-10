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

How to rebase:

```
$ rpm-ostree rebase ostree-unverified-image:registry:quay.io/travier/fedora-kinoite:latest

```
