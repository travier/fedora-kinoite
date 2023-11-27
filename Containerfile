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
        qemu-kvm \
        sysprof \
        vim \
        zsh \
    && \
    systemctl enable libvirtd.socket && \
    rm -rf /var/lib/unbound/root.key

# Copy custom config to /usr & /etc
COPY usr usr
COPY etc etc

# Setup container signing policy
RUN cat /etc/containers/policy.json | jq '.transports.docker["quay.io/travier/fedora-kinoite"] |= [{"type": "sigstoreSigned", "keyPath": "/etc/pki/containers/quay.io-travier-fedora-kinoite.pub", "signedIdentity": {"type": "matchRepository"}}]' | tee /etc/containers/policy.json

RUN ostree container commit
