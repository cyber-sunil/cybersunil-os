#!/usr/bin/env python3
# ==============================================================================
# CyberSunil OS - Windows Helper & ISO Builder Assistant
# ==============================================================================

import os
import sys
import subprocess
import webbrowser
import urllib.request
import shutil

PROJECT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
ISO_NAME = "CyberSunil-OS-1.0-amd64.iso"
ISO_PATH = os.path.join(PROJECT_DIR, ISO_NAME)

BASE_ISO_URL = "https://cdimage.debian.org/cdimage/archive/12.9.0-live/amd64/iso-hybrid/debian-live-12.9.0-amd64-xfce.iso"

BANNER = r"""
======================================================================
               CYBERSUNIL OS - WINDOWS ISO BUILDER                    
======================================================================
 Target OS:   CyberSunil OS 1.0 (Genesis)
 Output:      CyberSunil-OS-1.0-amd64.iso
 Destination: D:\CyberSunil-OS
======================================================================
"""

def check_wsl():
    try:
        res = subprocess.run(["wsl", "-l", "-q"], capture_output=True, text=True, timeout=5)
        distros = [d.strip().replace("\x00", "") for d in res.stdout.splitlines() if d.strip()]
        return len(distros) > 0, distros
    except Exception:
        return False, []

def download_progress(block_num, block_size, total_size):
    downloaded = block_num * block_size
    if total_size > 0:
        percent = min(100.0, (downloaded / total_size) * 100)
        mb_down = downloaded / (1024 * 1024)
        mb_total = total_size / (1024 * 1024)
        bar_len = 30
        filled = int(bar_len * downloaded // total_size)
        bar = "=" * filled + "-" * (bar_len - filled)
        sys.stdout.write(f"\r[{bar}] {percent:5.1f}% ({mb_down:6.1f} MB / {mb_total:6.1f} MB)")
        sys.stdout.flush()

def option_github():
    print("\n--- [Option 1] 1-Click Free Cloud Build with GitHub Actions ---")
    print("This compiles the full custom ISO on GitHub's 16-core cloud servers.")
    print("No Linux installation is required on your computer.\n")
    
    repo_url = input("Enter your GitHub repository URL (e.g. https://github.com/username/cybersunil-os.git): ").strip()
    if not repo_url:
        print("[-] Error: Repository URL cannot be empty.")
        return

    os.chdir(PROJECT_DIR)
    try:
        subprocess.run(["git", "remote", "remove", "origin"], capture_output=True)
    except Exception:
        pass
    
    print("[*] Adding GitHub remote origin...")
    subprocess.run(["git", "remote", "add", "origin", repo_url], check=True)
    print("[*] Pushing to GitHub (branch: main)...")
    push_res = subprocess.run(["git", "push", "-u", "origin", "master:main"])
    
    if push_res.returncode == 0:
        print("\n[+] SUCCESS! Pushed to GitHub.")
        actions_url = repo_url.rstrip(".git") + "/actions"
        print(f"[*] Opening GitHub Actions in your browser: {actions_url}")
        print("[*] In ~10-12 minutes, download CyberSunil-OS-1.0-amd64.iso from the Artifacts section!")
        try:
            webbrowser.open(actions_url)
        except Exception:
            pass
    else:
        print("[-] Git push failed. Please verify your repository URL and credentials.")

def option_wsl():
    print("\n--- [Option 2] Local Build via WSL (Ubuntu on Windows) ---")
    wsl_installed, distros = check_wsl()
    
    if not wsl_installed:
        print("\n[!] WSL is not currently installed or has no active distribution.")
        print("To install WSL on your Windows PC:")
        print("  1. Right-click Start Menu -> Click 'Windows PowerShell (Admin)'.")
        print("  2. Run:  wsl --install -d Ubuntu")
        print("  3. Restart your PC when prompted.")
        print("  4. Once rebooted, open Ubuntu and run:")
        print("       cd /mnt/d/CyberSunil-OS")
        print("       sudo bash build.sh\n")
        return
    
    print(f"[+] Detected WSL distributions: {', '.join(distros)}")
    print("[*] Launching build.sh inside WSL...")
    
    wsl_cmd = "cd /mnt/d/CyberSunil-OS && sudo bash build.sh"
    try:
        subprocess.run(["wsl", "bash", "-c", wsl_cmd])
    except Exception as e:
        print(f"[-] Execution failed: {e}")

def option_download_base():
    print("\n--- [Option 3] Download Live Base ISO for VirtualBox ---")
    print(f"Destination: {ISO_PATH}")
    
    if os.path.exists(ISO_PATH):
        overwrite = input(f"[!] {ISO_NAME} already exists! Overwrite? (y/n): ").strip().lower()
        if overwrite != 'y':
            print("[*] Cancelled.")
            return

    print(f"[*] Downloading 64-bit Live Hybrid Base ISO (~3 GB)...")
    print("This ISO boots directly into XFCE desktop in VirtualBox.\n")
    
    try:
        urllib.request.urlretrieve(BASE_ISO_URL, ISO_PATH, reporthook=download_progress)
        print(f"\n\n[SUCCESS] ISO Downloaded successfully to:")
        print(f"--> {ISO_PATH}")
        print("\nYou can now open VirtualBox, attach this ISO, and boot right away!")
    except Exception as e:
        print(f"\n[-] Download failed: {e}")

def main():
    while True:
        print(BANNER)
        print("Select how you want to create or obtain the ISO:")
        print("  [1] 1-Click Free Cloud Build (GitHub Actions - No Linux needed on PC)")
        print("  [2] Build Locally on this PC using WSL (Ubuntu)")
        print("  [3] Download Ready-to-Boot 64-bit Live ISO directly to D:\\CyberSunil-OS")
        print("  [4] Open VirtualBox Guide")
        print("  [5] Exit")
        print("=" * 70)
        
        choice = input("Enter choice (1-5): ").strip()
        
        if choice == "1":
            option_github()
        elif choice == "2":
            option_wsl()
        elif choice == "3":
            option_download_base()
        elif choice == "4":
            guide_path = os.path.join(PROJECT_DIR, "test", "VIRTUALBOX_GUIDE.md")
            if os.path.exists(guide_path):
                os.system(f'notepad.exe "{guide_path}"')
        elif choice == "5":
            print("Goodbye!")
            break
        else:
            print("[!] Invalid selection.")
        
        input("\nPress Enter to return to menu...")

if __name__ == "__main__":
    main()
