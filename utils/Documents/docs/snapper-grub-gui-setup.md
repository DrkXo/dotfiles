
# 📸 Snapper + GRUB + GUI Snapshot Management on Arch Linux

This guide sets up **Snapper** with **Btrfs**, **GRUB integration**, and a **GUI (snapper-gui)** for managing snapshots manually. It avoids `snap-pac` for simplicity.

---

## ✅ System Prerequisites

- Arch Linux
- Btrfs with root subvolume `@`
- GRUB bootloader
- Separate `/boot` partition (EFI)
- Your subvolumes look like:
  ```
  @      → /
  @home  → /home
  @log   → /var/log
  @pkg   → /var/cache/pacman/pkg
  ```

---

## 📦 1. Install Required Packages

```bash
sudo pacman -S snapper grub-btrfs
```

_No `snap-pac` is used in this guide._

---

## 📁 2. Create Snapper Config for Root

```bash
sudo snapper -c root create-config /
```

---

## 📂 3. Mount and Configure `.snapshots` Directory

```bash
sudo mkdir -p /.snapshots
sudo mount -o subvol=@/.snapshots UUID=<your-uuid> /.snapshots
```

### Add to `/etc/fstab`:

```fstab
UUID=<your-uuid> /.snapshots btrfs subvol=@/.snapshots,defaults,noatime,compress=zstd:3 0 0
```

Apply changes:

```bash
sudo mount -a
```

### Set permissions:

```bash
sudo chmod 750 /.snapshots
sudo chown :wheel /.snapshots
```

---

## ⏲️ 4. Enable Snapper Timers

```bash
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
sudo systemctl enable --now snapper-boot.timer
```

---

## 🔁 5. Enable GRUB Integration

```bash
sudo systemctl enable --now grub-btrfs.path
```

Check config (optional):

```bash
sudo nano /etc/grub-btrfs/config
```

Ensure:
```ini
USE_SNAPSHOT_BOOTING="true"
SNAPPER_CONFIG="root"
```

---

## 🔧 6. Regenerate GRUB Menu (once)

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## 🧪 7. Test Snapshot Creation

```bash
sudo snapper -c root create --description "Test snapshot"
```

Check GRUB snapshot menu:

```bash
cat /boot/grub/grub-btrfs.cfg
```

Reboot and look for **Snapshots >** in GRUB menu.

---

## 🖼️ 8. Install and Use Snapper GUI

### Install:

```bash
yay -S snapper-gui
```

### Launch with root:

```bash
sudo snapper-gui
```

### To create a snapshot:

1. Select `root` config.
2. Click ➕ or `Create Snapshot`
3. Enter a description and confirm.

---

## 🧷 9. Optional: Create Desktop Launcher for GUI

Create file:
```bash
nano ~/.local/share/applications/snapper-gui-root.desktop
```

Paste:
```ini
[Desktop Entry]
Type=Application
Name=Snapper GUI (Root)
Exec=pkexec snapper-gui
Icon=snapper
Categories=System;Settings;
```

---

## 🎉 Done!

You now have:
- Snapper set up safely for `/`
- Snapshots listed in GRUB at boot
- A working GUI to manage them

---

## 🧩 Optional Extras

- [ ] Dolphin integration for file restore
- [ ] Auto rollback scripts
- [ ] Snapper for `/home` or other volumes
- [ ] CLI: `snapper ls`, `snapper undochange`, etc.

Let me know if you'd like help with any of these.
