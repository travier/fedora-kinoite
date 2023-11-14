# Location not final and subject to change!
FROM quay.io/fedora-ostree-desktops/kinoite:39

RUN rpm-ostree install \
        distrobox \
        htop \
        iwd \
        libvirt-daemon \
        libvirt-daemon-config-network \
        libvirt-daemon-driver-interface \
        libvirt-daemon-driver-network \
        libvirt-daemon-driver-nwfilter \
        libvirt-daemon-driver-qemu \
        libvirt-daemon-driver-secret \
        libvirt-daemon-driver-storage-core \
        libvirt-dbus \
        qemu-kvm \
        sysprof \
        vim \
        zsh \
    && \
    systemctl enable libvirtd.socket && \
    rm -rf /var/lib/unbound/root.key && \
    ostree container commit
