@echo off
REM ==============================================================================
REM CyberSunil OS - QEMU Test Runner for Windows
REM ==============================================================================

set ISO_FILE=CyberSunil-OS-1.0-amd64.iso

if not exist "%ISO_FILE%" (
    echo [-] Error: %ISO_FILE% not found in the current directory!
    echo Please make sure the ISO is built or placed here first.
    pause
    exit /b 1
)

echo [*] Launching CyberSunil OS in QEMU...
echo [*] Memory: 4096MB | Cores: 4 | Display: VGA
qemu-system-x86_64 ^
    -m 4096 ^
    -smp 4 ^
    -cdrom "%ISO_FILE%" ^
    -boot d ^
    -vga virtio ^
    -display default,show-cursor=on ^
    -enable-kvm 2>nul || qemu-system-x86_64 -m 4096 -smp 4 -cdrom "%ISO_FILE%" -boot d -vga std

pause
