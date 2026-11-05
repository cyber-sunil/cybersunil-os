# CyberSunil OS 🚀

> **Version**: 1.0 "Genesis"  
> **Base**: Debian GNU/Linux 12 (Bookworm) x86_64  
> **Desktop**: XFCE 4.18 (Cyber Modern Theme)  
> **Target**: VirtualBox, QEMU, VMware, or Real PC Hardware (Bootable Hybrid ISO)  
> **Key Feature**: Native **Windows Bridge (.EXE / .MSI)** support via pre-configured Wine, 32-bit multiarch, and Vulkan DXVK acceleration.

---

## 🌟 Key Highlights

* **Windows App & Game Ready**:
  * Multi-architecture (`amd64` + `i386`) enabled out of the box.
  * Double-click `.exe` or `.msi` to run and install Windows programs directly.
  * Direct kernel binary execution support (`binfmt_misc`).
  * Vulkan-powered DirectX 9/10/11 translation via **DXVK**.
* **Modern & Lightweight**:
  * Sleek dark Cyber-themed UI with custom wallpaper and icons.
  * Idles at under **550 MB RAM**, making it blazing fast even inside VirtualBox with modest specs.
* **Dual Bootable Hybrid ISO**:
  * Boots seamlessly on both **Legacy BIOS (MBR)** and **Modern UEFI (GPT)** systems.
  * Live mode lets you test everything without installing.
  * Includes the graphical **Calamares Installer** to install CyberSunil OS permanently to hard disks or VirtualBox drives with 1 click.

---

## 📂 Project Architecture

```
cybersunil-os/
├── build.sh                             # Master build script (debootstrap + squashfs + xorriso)
├── .github/workflows/build-iso.yml      # 1-Click Cloud ISO Builder via GitHub Actions
├── config/
│   ├── packages/
│   │   └── packages.list.chroot         # Full Debian package manifest (Wine, Desktop, Drivers)
│   ├── wine/
│   │   ├── cybersunil-wine-launcher.sh  # GUI launcher wrapper for .exe & .msi
│   │   ├── cybersunil-wine-launcher.desktop # File manager MIME associations
│   │   └── binfmt-wine.conf             # Linux kernel binfmt_misc rule
│   ├── desktop/
│   │   ├── install-cybersunil.desktop   # Desktop shortcut for Calamares installer
│   │   ├── wine-config.desktop          # Desktop shortcut for Wine configuration
│   │   └── theme/
│   │       ├── os-release               # OS identity metadata
│   │       └── wallpaper.svg            # Custom CyberSunil OS 1080p Wallpaper
│   ├── installer/
│   │   └── calamares/                   # Calamares graphical installer branding & flow
│   └── boot/
│       ├── grub.cfg                     # Modern UEFI bootloader menu
│       └── isolinux.cfg                 # Legacy BIOS bootloader menu
└── test/
    ├── VIRTUALBOX_GUIDE.md              # Detailed step-by-step VirtualBox guide
    └── run-qemu.bat                     # Windows batch script to test-boot ISO
```

---

## 🛠️ How to Build the ISO (`CyberSunil-OS-1.0-amd64.iso`)

You have two easy ways to compile the full bootable ISO:

### Option 1: 1-Click Free Cloud Build (Recommended for Windows)

No Linux machine, WSL, or GBs of dependencies required on your local computer:

1. Push this `cybersunil-os` directory to a new repository on your GitHub account:
   ```bash
   git init
   git add .
   git commit -m "Initial CyberSunil OS commit"
   git remote add origin https://github.com/<your-username>/cybersunil-os.git
   git push -u origin main
   ```
2. Navigate to your GitHub repo's **Actions** tab.
3. The **"Build CyberSunil OS Bootable ISO"** workflow will automatically run on GitHub's 16-core cloud runners.
4. When finished (in ~10-12 minutes), download `CyberSunil-OS-1.0-amd64.iso` straight from the **Artifacts** section!

---

### Option 2: Local Build (Linux / WSL2)

If you have a Linux system or WSL2:

```bash
# Make script executable
chmod +x build.sh

# Run builder with root/sudo privileges
sudo ./build.sh
```

The script will automate:
1. Downloading and bootstrapping the base Debian 12 filesystem.
2. Configuring 32-bit multiarch, Wine, XFCE, and Calamares.
3. Applying CyberSunil OS branding, wallpapers, and desktop entries.
4. Compressing the filesystem into a high-density squashfs image.
5. Packaging the hybrid UEFI/BIOS bootloaders with `xorriso`.
6. Outputting `CyberSunil-OS-1.0-amd64.iso` in the root folder.

---

## 💻 Running & Installing in VirtualBox

1. Open **VirtualBox** -> Click **New**.
2. Set Type: `Linux`, Version: `Debian (64-bit)`.
3. Select `CyberSunil-OS-1.0-amd64.iso`.
4. Allocate at least **2 CPU cores** and **4 GB RAM** (4096 MB).
5. In VM Settings -> **Display**, set Video Memory to `128 MB` and enable **3D Acceleration**.
6. Click **Start**!
7. Once on the desktop, double click **"Install CyberSunil OS"** to permanently install it to your virtual disk.

*For full instructions, read [VIRTUALBOX_GUIDE.md](file:///D:/CyberSunil-OS/test/VIRTUALBOX_GUIDE.md).*

---

## 🎮 Running Windows (.EXE) Programs

In CyberSunil OS:
1. Download or copy any `.exe` or `.msi` file (e.g., 7-Zip, Notepad++, game installers).
2. Simply **double-click** the executable.
3. The **CyberSunil Windows Bridge** handles everything automatically, initializing Wine and running the Windows setup wizard or application seamlessly.
