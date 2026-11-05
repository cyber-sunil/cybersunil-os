#!/bin/bash
# ==============================================================================
# CyberSunil OS - Hacker Console Greeting & Diagnostics
# ==============================================================================

# ANSI Color Codes
G="\e[1;32m"   # Neon Green
C="\e[1;36m"   # Cyber Cyan
R="\e[1;31m"   # Red
Y="\e[1;33m"   # Yellow
W="\e[1;37m"   # White
M="\e[1;35m"   # Magenta
Z="\e[0m"      # Reset

clear
echo -e "${C}"
cat << "EOF"
  ██████╗██╗   ██╗██████╗ ███████╗██████╗ ███████╗██╗   ██╗███╗   ██╗██╗██╗     
 ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔════╝██║   ██║████╗  ██║██║██║     
 ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝███████╗██║   ██║██╔██╗ ██║██║██║     
 ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗╚════██║██║   ██║██║╚██╗██║██║██║     
 ╚██████╗   ██║   ██████╔╝███████╗██║  ██║███████║╚██████╔╝██║ ╚████║██║███████╗
  ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚══════╝
EOF
echo -e "                   ${G}[ CYBERSUNIL OS 1.0 (GENESIS) - HACKER EDITION ]${Z}"
echo -e "${C}══════════════════════════════════════════════════════════════════════════════════${Z}"
echo -e "  ${G}[+] KERNEL PRIVILEGE :${Z} ${W}$(uname -srm)${Z} [PROTECTED]"
echo -e "  ${G}[+] SECURITY SHIELD  :${Z} ${W}FIREWALL ACTIVE // APP-ARMOR LOADED${Z}"
echo -e "  ${G}[+] WINDOWS BRIDGE   :${Z} ${C}ONLINE${Z} (Directly double-click or run ${Y}.exe / .msi${Z})"
echo -e "  ${G}[+] USER ENVIRONMENT :${Z} ${M}$USER${Z}@${C}$(hostname)${Z} [SUDO PRIVILEGED]"
echo -e "${C}══════════════════════════════════════════════════════════════════════════════════${Z}"
echo -e "  ${Y}>> SYSTEM READY. Double-click .exe to run Windows apps, or type commands below. <<${Z}\n"
