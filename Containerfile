# Location not final and subject to change!
FROM quay.io/fedora-ostree-desktops/kinoite:39

LABEL org.opencontainers.image.title="Fedora Kinoite"
LABEL org.opencontainers.image.description="Customized image of Fedora Kinoite"
LABEL org.opencontainers.image.source="https://github.com/travier/fedora-kinoite"
LABEL org.opencontainers.image.licenses="MIT"

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
        netcat \
        qemu-kvm \
        sysprof \
        vim \
        zsh \
    && \
    wget \
        "https://kojipkgs.fedoraproject.org//work/tasks/6712/110246712/plasma-discover-5.27.9-2.fc39.x86_64.rpm" \
        "https://kojipkgs.fedoraproject.org//work/tasks/6712/110246712/plasma-discover-flatpak-5.27.9-2.fc39.x86_64.rpm" \
        "https://kojipkgs.fedoraproject.org//work/tasks/6712/110246712/plasma-discover-libs-5.27.9-2.fc39.x86_64.rpm" \
        "https://kojipkgs.fedoraproject.org//work/tasks/6712/110246712/plasma-discover-notifier-5.27.9-2.fc39.x86_64.rpm" \
        "https://kojipkgs.fedoraproject.org//work/tasks/6712/110246712/plasma-discover-rpm-ostree-5.27.9-2.fc39.x86_64.rpm" \
    && \
    rpm-ostree override replace ./plasma-discover-*.rpm \
    && \
    rm -v plasma-discover-*.rpm \
    && \
    systemctl enable libvirtd.socket \
    && \
    rm -rf /var/lib/unbound/root.key

# Copy custom config to /usr & /etc
COPY usr usr
COPY etc etc

RUN ostree container commit
