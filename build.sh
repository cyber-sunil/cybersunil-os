#!/usr/bin/env bash
# ==============================================================================
# CyberSunil OS - Master ISO Build Script
# Generates a bootable Hybrid UEFI/BIOS ISO image for VirtualBox and Real Hardware
# ==============================================================================

set -euo pipefail

OS_NAME="CyberSunil-OS"
VERSION="1.0"
ARCH="amd64"
DISTRO_CODENAME="bookworm"
MIRROR="http://deb.debian.org/debian"

WORK_DIR="$(pwd)/build_workspace"
ROOTFS="$WORK_DIR/rootfs"
LIVE_DIR="$WORK_DIR/iso"
OUTPUT_ISO="$(pwd)/${OS_NAME}-${VERSION}-${ARCH}.iso"

echo "=========================================================="
echo " Building: $OS_NAME v$VERSION ($ARCH)"
echo " Output Target: $OUTPUT_ISO"
echo "=========================================================="

# Check root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "[-] Error: This build script must be run as root (or via sudo)."
    exit 1
fi

# Step 1: Install build prerequisites
echo "[+] Step 1/6: Checking and installing host build tools..."
DEBIAN_FRONTEND=noninteractive apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-efi \
    mtools \
    dosfstools \
    grub-pc-bin \
    grub-efi-amd64-bin \
    rsync \
    curl \
    wget

# Step 2: Clean and setup workspace
echo "[+] Step 2/6: Setting up build workspace at $WORK_DIR..."
rm -rf "$WORK_DIR"
mkdir -p "$ROOTFS" "$LIVE_DIR/live" "$LIVE_DIR/boot/grub" "$LIVE_DIR/isolinux" "$LIVE_DIR/EFI/boot"

# Step 3: Debootstrap Debian base system
echo "[+] Step 3/6: Debootstrapping base system ($DISTRO_CODENAME)..."
debootstrap --arch="$ARCH" --variant=minbase "$DISTRO_CODENAME" "$ROOTFS" "$MIRROR"

# Mount virtual filesystems for chroot operations
mount --bind /dev "$ROOTFS/dev"
mount --bind /run "$ROOTFS/run"
mount -t devpts devpts "$ROOTFS/dev/pts"
mount -t proc proc "$ROOTFS/proc"
mount -t sysfs sysfs "$ROOTFS/sys"

cleanup() {
    echo "[*] Cleaning up mounted filesystems..."
    umount -lf "$ROOTFS/dev/pts" 2>/dev/null || true
    umount -lf "$ROOTFS/dev" 2>/dev/null || true
    umount -lf "$ROOTFS/run" 2>/dev/null || true
    umount -lf "$ROOTFS/proc" 2>/dev/null || true
    umount -lf "$ROOTFS/sys" 2>/dev/null || true
}
trap cleanup EXIT

# Configure APT sources inside chroot
cat << EOF > "$ROOTFS/etc/apt/sources.list"
deb $MIRROR $DISTRO_CODENAME main contrib non-free non-free-firmware
deb $MIRROR $DISTRO_CODENAME-updates main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security $DISTRO_CODENAME-security main contrib non-free non-free-firmware
EOF

# Copy configurations and hooks into rootfs
mkdir -p "$ROOTFS/tmp/config"
cp -r config/* "$ROOTFS/tmp/config/"

# Step 4: Install packages and configure system inside chroot
echo "[+] Step 4/6: Installing kernel, XFCE desktop, Wine and utilities..."
cat << 'EOF' > "$ROOTFS/tmp/chroot-build.sh"
#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

# Add 32-bit architecture for Windows .EXE support
dpkg --add-architecture i386
apt-get update

# Install all packages listed in package manifest
grep -v '^#' /tmp/config/packages/packages.list.chroot | grep -v '^$' | xargs apt-get install -y --no-install-recommends

# Run CyberSunil customizations hook
chmod +x /tmp/config/hooks/01-setup-cybersunil.chroot
/tmp/config/hooks/01-setup-cybersunil.chroot

# Clean up apt caches to minimize ISO size
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/config
EOF

chmod +x "$ROOTFS/tmp/chroot-build.sh"
chroot "$ROOTFS" /tmp/chroot-build.sh
rm -f "$ROOTFS/tmp/chroot-build.sh"

# Extract Kernel and Initramfs for the Live Bootloader
echo "[+] Step 5/6: Extracting kernel and packing squashfs..."
cp "$ROOTFS"/boot/vmlinuz-* "$LIVE_DIR/live/vmlinuz"
cp "$ROOTFS"/boot/initrd.img-* "$LIVE_DIR/live/initrd.img"

# Unmount before squashing
cleanup
trap - EXIT

# Compress Root Filesystem into squashfs
mksquashfs "$ROOTFS" "$LIVE_DIR/live/filesystem.squashfs" -comp xz -b 1048576 -noappend

# Copy Bootloader Configurations
cp config/boot/grub.cfg "$LIVE_DIR/boot/grub/grub.cfg"
cp config/boot/isolinux.cfg "$LIVE_DIR/isolinux/isolinux.cfg"
cp /usr/lib/ISOLINUX/isolinux.bin "$LIVE_DIR/isolinux/" 2>/dev/null || true
cp /usr/lib/syslinux/modules/bios/* "$LIVE_DIR/isolinux/" 2>/dev/null || true

# Prepare EFI boot image
dd if=/dev/zero of="$LIVE_DIR/boot/grub/efi.img" bs=1M count=10
mkfs.vfat "$LIVE_DIR/boot/grub/efi.img"
mmd -i "$LIVE_DIR/boot/grub/efi.img" efi efi/boot
mcopy -i "$LIVE_DIR/boot/grub/efi.img" /usr/lib/grub/x86_64-efi/monolithic/gcdx64.efi ::efi/boot/bootx64.efi 2>/dev/null || true

# Step 6: Generate Hybrid Bootable ISO
echo "[+] Step 6/6: Generating Hybrid Bootable ISO with xorriso..."
xorriso -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "CYBERSUNIL_OS" \
    -eltorito-boot isolinux/isolinux.bin \
    -eltorito-catalog isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -eltorito-alt-boot \
    -e boot/grub/efi.img \
    -no-emul-boot -isohybrid-gpt-basdat \
    -output "$OUTPUT_ISO" \
    "$LIVE_DIR"

echo "=========================================================="
echo " [SUCCESS] CyberSunil OS ISO Created Successfully!"
echo " ISO File: $OUTPUT_ISO"
echo " Size: $(du -h "$OUTPUT_ISO" | cut -f1)"
echo " You can now boot this in VirtualBox, QEMU, or flash to USB!"
echo "=========================================================="
