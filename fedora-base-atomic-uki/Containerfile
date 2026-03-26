FROM quay.io/fedora-ostree-desktops/base-atomic:43 as rootfs

LABEL org.opencontainers.image.title="Fedora Base Atomic UKI"
LABEL org.opencontainers.image.source="https://github.com/travier/fedora-kinoite"
LABEL org.opencontainers.image.licenses="MIT"
LABEL quay.expires-after=""

RUN <<EORUN
set -euo pipefail
set -x

# We don't want openh264
rm -f "/etc/yum.repos.d/fedora-cisco-openh264.repo"

# Install fsverity utils to make it easier to check things
# Install systemd-boot (will be replaced by the signed version later)
dnf install -y fsverity-utils systemd-boot-unsigned
dnf clean all

# Uninstall bootupd (no support for systemd-boot yet)
rpm -e bootupd
rm -vrf "/usr/lib/bootupd/updates"

# mkdir -p "/usr/lib/bootc/kargs.d"
cat > "/usr/lib/bootc/kargs.d/10-rootfs-rw.toml" << 'EOF'
# Mount the root filesystem read-write
kargs = ["rw"]
EOF

# Default to btrfs
# mkdir -p "/usr/lib/bootc/install"
cat > "/usr/lib/bootc/install/80-rootfs.toml" << 'EOF'
[install.filesystem.root]
type = "btrfs"
EOF

# Dracut will always fail to set security.selinux xattrs at build time
# https://github.com/dracut-ng/dracut-ng/issues/1561
cat > "/usr/lib/dracut/dracut.conf.d/20-bootc-base.conf" << 'EOF'
export DRACUT_NO_XATTR=1
EOF

# Enable composefs backend in dracut
cat > "/usr/lib/dracut/dracut.conf.d/20-bootc-composefs.conf" << 'EOF'
add_dracutmodules+=" bootc "
EOF

# Rebuild the initramfs to get bootc-initramfs-setup
kver=$(cd "/usr/lib/modules" && echo *)
dracut -vf --install "/etc/passwd /etc/group" "/usr/lib/modules/$kver/initramfs.img" "$kver"

bootc container lint
EORUN

COPY /systemd-bootx64.efi /usr/lib/systemd/boot/efi/systemd-bootx64.efi

FROM quay.io/fedora-ostree-desktops/base-atomic:43 as sealed-uki
RUN --mount=type=bind,from=rootfs,target=/target \
    --mount=type=secret,id=secureboot_key \
    --mount=type=secret,id=secureboot_cert <<EORUN
set -euo pipefail
set -x

# We don't want openh264
rm -f "/etc/yum.repos.d/fedora-cisco-openh264.repo"

# Install ukify & signing tools
dnf install -y systemd-ukify sbsigntools
dnf clean all

target="/target"
output="/out"
secrets="/run/secrets"

mkdir -p /out

# Find the kernel version (needed for output filename)
kver=$(bootc container inspect --rootfs "${target}" --json | jq -r '.kernel.version')
if [ -z "$kver" ] || [ "$kver" = "null" ]; then
  echo "Error: No kernel found" >&2
  exit 1
fi

# Baseline ukify options
ukifyargs=(--measure
           --json pretty
           --output "${output}/${kver}.efi")

# Signing options, we use sbsign by default
ukifyargs+=(--signtool sbsign
            --secureboot-private-key "${secrets}/secureboot_key"
            --secureboot-certificate "${secrets}/secureboot_cert")

# Baseline container ukify options
containerukifyargs=(--rootfs "${target}")

# Build the UKI using bootc container ukify
# This computes the composefs digest, reads kargs from kargs.d, and invokes ukify
bootc container ukify "${containerukifyargs[@]}" "${missing_verity[@]}" -- "${ukifyargs[@]}"
EORUN

FROM rootfs
COPY --from=sealed-uki /out/*.efi /boot/EFI/Linux/
