# VirtualBox Setup Guide for CyberSunil OS

Follow these steps to run or install **CyberSunil OS** inside Oracle VirtualBox.

---

## 1. Create a New Virtual Machine

1. Open **VirtualBox** and click **New** (or press `Ctrl+N`).
2. Fill in the basic configuration:
   * **Name**: `CyberSunil OS`
   * **Folder**: (Default or your preferred VM storage directory)
   * **ISO Image**: Select `CyberSunil-OS-1.0-amd64.iso`
   * **Type**: `Linux`
   * **Version**: `Debian (64-bit)`
   * Check **"Skip Unattended Installation"** (if prompted).
3. Click **Next**.

---

## 2. Hardware Allocation

* **Base Memory (RAM)**:
  * Minimum: `2048 MB` (2 GB)
  * Recommended: `4096 MB` (4 GB) or higher for running Windows games/heavy .EXE applications.
* **Processors (CPU)**:
  * Allocate **2 to 4 CPU cores** for smooth desktop and Wine translation performance.
* Click **Next**.

---

## 3. Virtual Hard Disk

* Select **Create a Virtual Hard Disk Now**.
* **Disk Size**:
  * Minimum: `25 GB`
  * Recommended: `40 GB – 60 GB` (provides plenty of space for Windows games and software).
* Click **Finish**.

---

## 4. Recommended VM Settings (Before Booting)

Select your VM and click **Settings** (or press `Ctrl+S`):

1. **System -> Motherboard**:
   * Enable **I/O APIC**.
   * (Optional) Check **Enable EFI (special OSes only)** if you want UEFI boot.
2. **Display -> Screen**:
   * **Video Memory**: Slide all the way to `128 MB`.
   * **Graphics Controller**: Set to `VMSVGA` (Linux default).
   * Check **Enable 3D Acceleration** (Crucial for Wine DXVK / Vulkan acceleration).
3. **General -> Advanced**:
   * **Shared Clipboard**: `Bidirectional`
   * **Drag'n'Drop**: `Bidirectional`
4. Click **OK**.

---

## 5. Booting and Installing

1. Click **Start** to power on the VM.
2. The **CyberSunil OS Boot Menu** will appear:
   * Select **Start CyberSunil OS 1.0 (Live & Installer)**.
3. The system will auto-login to the **CyberSunil OS XFCE Desktop**:
   * **To test in Live Mode**: Open Firefox, browse the web, or run Wine directly without modifying any disks.
   * **To install permanently**: Double-click the **Install CyberSunil OS** icon on the desktop. The graphical Calamares installer will guide you through partitioning the virtual hard disk, creating your user account, and installing GRUB.
4. Once installation finishes, shut down the VM, go to **Settings -> Storage**, remove the ISO from the optical drive, and start the VM again. CyberSunil OS is now installed on your virtual hard drive!

---

## 6. Running and Installing Windows (.EXE) Apps

1. In CyberSunil OS, open the web browser and download any `.exe` or `.msi` (for example, Notepad++, 7-Zip, Steam, or a standalone game).
2. Open the file manager (**Thunar**) and locate the downloaded file.
3. **Double-click** the `.exe` file!
4. The **CyberSunil Windows Bridge** will automatically handle runtime initialization, display the Windows setup wizard, install the application into `~/.wine/drive_c/Program Files/`, and place a launcher in your application menu and desktop.
