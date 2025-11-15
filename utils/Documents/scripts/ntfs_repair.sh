#!/usr/bin/env bash
# 🛠 NTFS Repair Helper Script using ntfsfix
# Supports basic repair, dry-run, clear bad sectors, clear dirty flag

set -e

echo "=== NTFS Repair Helper ==="

# List NTFS partitions
echo "[*] Detecting NTFS partitions..."
lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT | grep ntfs || { echo "No NTFS partitions found."; exit 1; }

# Ask user for partition
read -rp "Enter the NTFS partition to repair (e.g., /dev/sda5): " PARTITION

# Confirm the partition exists
if [ ! -b "$PARTITION" ]; then
    echo "Error: Partition $PARTITION does not exist."
    exit 1
fi

# Show menu
echo "Select repair option:"
echo "1) Basic repair"
echo "2) Dry-run"
echo "3) Clear bad sectors"
echo "4) Clear dirty flag"

read -rp "Enter choice [1-4]: " CHOICE

case "$CHOICE" in
    1)
        echo "[*] Running basic repair on $PARTITION..."
        sudo ntfsfix "$PARTITION"
        ;;
    2)
        echo "[*] Running dry-run on $PARTITION..."
        sudo ntfsfix -n "$PARTITION"
        ;;
    3)
        echo "[*] Clearing bad sectors on $PARTITION..."
        sudo ntfsfix -b "$PARTITION"
        ;;
    4)
        echo "[*] Clearing dirty flag on $PARTITION..."
        sudo ntfsfix -d "$PARTITION"
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo "[✔] Operation completed."
