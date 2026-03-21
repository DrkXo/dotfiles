#!/usr/bin/env bash

set -e

echo "== Btrfs Snapshot Cleanup =="

# Enable safe globbing
shopt -s nullglob

echo
echo "[*] Deleting ROOT snapshots..."

for snap in /.snapshots/*/snapshot; do
    if [ -d "$snap" ]; then
        echo "Deleting $snap"
        sudo btrfs subvolume delete "$snap"
    fi
done

echo
echo "[*] Deleting HOME snapshots..."

for snap in /home/.snapshots/*/snapshot; do
    if [ -d "$snap" ]; then
        echo "Deleting $snap"
        sudo btrfs subvolume delete "$snap"
    fi
done

echo
echo "[*] Running balance to reclaim space..."
sudo btrfs balance start -dusage=75 /

echo
echo "✅ Cleanup complete!"
echo "👉 Check disk usage with: df -h"
