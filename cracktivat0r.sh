#!/bin/bash

# ANSI Color Codes
PURPLE='\033[1;35m'      # Bold Purple (for Header)
DEEP_PURPLE='\033[0;35m' # Deep Purple (for Completed text)
LIGHT_BROWN='\033[0;33m' # Light Brown / Yellow-Brown
GREEN='\033[1;32m'       # Bold Green
YELLOW='\033[1;33m'      # Yellow
BOLD='\033[1m'
NC='\033[0m'             # No Color

# Function for equal sign loading bar
loading_bar() {
    local task_name="$1"
    echo -e "${LIGHT_BROWN}Running: $task_name${NC}"
    for i in $(seq 0 20 100); do
        printf "${GREEN}["
        local count=$((i / 5))
        printf "%0.s=" $(seq 1 $count)
        local spaces=$((20 - count))
        printf "%0.s " $(seq 1 $spaces)
        printf "] %d%%${NC}\r" "$i"
        sleep 0.1
    done
    echo -e "\n${DEEP_PURPLE}Completed: $task_name${NC}\n"
}

clear

# Header and Support Info (Bold)
echo "------------------------------------------------------------------"
echo -e "${PURPLE}${BOLD}Cracktivat0r by mir7${NC}"
echo -e "${BOLD}Supports all devices running iOS 7.0 to iOS 10.2.1${NC}"
echo "------------------------------------------------------------------"

echo -e "\n${YELLOW}Notice:- This only bypasses the setup screen not the iCloud activation lock entirely${NC}\n"

# User Prompts
read -p "Press enter to continue..."
echo ""
read -p "Please press enter after booting an SSH Ramdisk..."
echo ""

# Start iproxy in the background
echo -e "${LIGHT_BROWN}Starting iproxy in the background...${NC}"
iproxy 2222 22 >/dev/null 2>&1 &
IPROXY_PID=$!
sleep 1

# Step 1: Connect and run mount_hfs using full path
loading_bar "Connecting via SSH & Mounting filesystem"
sshpass -p 'alpine' ssh -p 2222 -o StrictHostKeyChecking=no root@localhost "/sbin/mount_hfs /dev/disk0s1s1 /mnt1"

# Sleep 3 seconds between mount_hfs and rm -rf
sleep 3

# Step 2: Remove Setup.app with loading bar
loading_bar "Removing Setup.app"
sshpass -p 'alpine' ssh -p 2222 -o StrictHostKeyChecking=no root@localhost "rm -rf /mnt1/Applications/Setup.app"

# Sleep 5 seconds between rm -rf and reboot
sleep 5

# Step 3: Reboot device using full path
loading_bar "Rebooting device"
sshpass -p 'alpine' ssh -p 2222 -o StrictHostKeyChecking=no root@localhost "/sbin/reboot"

# Kill the background iproxy process
kill $IPROXY_PID 2>/dev/null

# Final completion message
echo -e "${GREEN}${BOLD}All Done! Enjoy Your Unlocked iDevice${NC}"