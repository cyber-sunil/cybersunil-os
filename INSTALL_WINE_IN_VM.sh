#!/usr/bin/env bash
# ==============================================================================
# CyberSunil OS - In-VM Quick Installer for Wine & Windows Bridge
# Run this inside the VirtualBox VM to enable instant .EXE execution!
# ==============================================================================

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "[-] Please run with sudo: sudo bash INSTALL_WINE_IN_VM.sh"
    exit 1
fi

echo "=========================================================="
echo " Setting up CyberSunil OS Windows Bridge (.EXE Support)"
echo "=========================================================="

echo "[+] 1/5: Adding 32-bit architecture..."
dpkg --add-architecture i386
apt-get update

echo "[+] 2/5: Installing Wine, DXVK, Vulkan, and Winetricks..."
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    wine \
    wine32:i386 \
    wine64 \
    winetricks \
    libwine \
    libwine:i386 \
    mesa-vulkan-drivers \
    mesa-vulkan-drivers:i386 \
    vulkan-tools \
    cabextract \
    zenity \
    xdg-utils

echo "[+] 3/5: Installing CyberSunil Windows Bridge launcher..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/config/wine/cybersunil-wine-launcher.sh" /usr/local/bin/cybersunil-wine-launcher
chmod +x /usr/local/bin/cybersunil-wine-launcher
cp "$SCRIPT_DIR/config/wine/cybersunil-wine-launcher.desktop" /usr/share/applications/

echo "[+] 4/5: Registering .EXE and .MSI file associations..."
xdg-mime default cybersunil-wine-launcher.desktop application/x-ms-dos-executable
xdg-mime default cybersunil-wine-launcher.desktop application/x-msi
xdg-mime default cybersunil-wine-launcher.desktop application/x-msdownload

echo "[+] 5/5: Applying CyberSunil OS Branding & Hacker Boot Screen..."
mkdir -p /usr/share/backgrounds/cybersunil
cp "$SCRIPT_DIR/config/desktop/theme/wallpaper.svg" /usr/share/backgrounds/cybersunil/wallpaper.svg 2>/dev/null || true
cp "$SCRIPT_DIR/config/desktop/theme/os-release" /etc/os-release 2>/dev/null || true

# Hacker Plymouth Theme
mkdir -p /usr/share/plymouth/themes/cybersunil-hacker
cp -r "$SCRIPT_DIR"/config/plymouth/cybersunil-hacker/* /usr/share/plymouth/themes/cybersunil-hacker/ 2>/dev/null || true
if command -v plymouth-set-default-theme >/dev/null 2>&1; then
    plymouth-set-default-theme cybersunil-hacker || true
    update-initramfs -u || true
fi

# Hacker MOTD & Bash Prompt
cp "$SCRIPT_DIR/config/desktop/theme/hacker-motd.sh" /etc/profile.d/cybersunil-hacker.sh 2>/dev/null || true
chmod +x /etc/profile.d/cybersunil-hacker.sh 2>/dev/null || true

echo "=========================================================="
echo " [SUCCESS] CyberSunil OS Windows Bridge is Ready!"
echo " You can now double-click any .EXE or .MSI file to run it!"
echo "=========================================================="
