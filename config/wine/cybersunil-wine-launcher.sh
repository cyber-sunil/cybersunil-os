#!/usr/bin/env bash
# ==============================================================================
# CyberSunil OS - Windows Bridge Executable Launcher
# Automatically handles .exe and .msi files via Wine
# ==============================================================================

TARGET_FILE="$1"

if [ -z "$TARGET_FILE" ]; then
    zenity --error --title="CyberSunil Windows Bridge" \
           --text="No executable specified to run."
    exit 1
fi

FILE_NAME=$(basename "$TARGET_FILE")
WINEPREFIX="${WINEPREFIX:-$HOME/.wine}"
export WINEPREFIX
export WINEARCH="${WINEARCH:-win64}"

# First-time Wine prefix initialization banner
if [ ! -d "$WINEPREFIX" ]; then
    (
        echo "10"; echo "# Initializing CyberSunil Windows Compatibility Layer..."; sleep 1
        wineboot --init > /dev/null 2>&1
        echo "90"; echo "# Finalizing Windows environment..."; sleep 1
        echo "100"; echo "# Ready!"
    ) | zenity --progress --title="CyberSunil Windows Bridge" \
               --text="Setting up Windows environment for the first time..." \
               --percentage=0 --auto-close
fi

# Detect extension
EXTENSION="${TARGET_FILE##*.}"
EXTENSION=$(echo "$EXTENSION" | tr '[:upper:]' '[:lower:]')

# Notify user
notify-send "CyberSunil Windows Bridge" "Starting $FILE_NAME..." --icon=wine 2>/dev/null || true

# Execute based on type
if [ "$EXTENSION" = "msi" ]; then
    wine msiexec /i "$TARGET_FILE"
else
    wine "$TARGET_FILE"
fi

EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo "[CyberSunil Windows Bridge] Process exited with status $EXIT_CODE"
fi
