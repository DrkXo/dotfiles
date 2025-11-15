# TLP Configuration for Lenovo Legion Y530 (Arch Linux)

This document contains a balanced and optimized `tlp.conf` setup for the Lenovo Legion Y530 running Arch Linux with KDE Plasma.

## 🖥️ Hardware Summary

* **CPU**: Intel i5-8300H (4C/8T)
* **GPU**: Intel UHD 630 (iGPU) + NVIDIA GTX 1050 (dGPU)
* **Battery**: Supported via ideapad\_laptop (binary conservation mode)
* **DE**: KDE Plasma 6 (Wayland)

---

## ✅ Final `/etc/tlp.conf`

```ini
# CPU Governor
CPU_SCALING_GOVERNOR_ON_AC=schedutil
CPU_SCALING_GOVERNOR_ON_BAT=powersave

# Energy Performance Policy
CPU_ENERGY_PERF_POLICY_ON_AC=balance_performance
CPU_ENERGY_PERF_POLICY_ON_BAT=power

# Runtime Power Management
RUNTIME_PM_ON_AC=on
RUNTIME_PM_ON_BAT=auto

# USB Autosuspend
USB_AUTOSUSPEND=1

# NVIDIA Power Control
NVIDIA_RUNTIME_PM_ON_AC=on
NVIDIA_RUNTIME_PM_ON_BAT=auto

# Restore Wi-Fi/Bluetooth state
RESTORE_DEVICE_STATE_ON_STARTUP=1
```

---

## 🔍 Notes

* **`schedutil`** is efficient and dynamic, suitable for modern CPUs.
* **Binary charge thresholds** supported via ideapad driver; no need to set custom thresholds.
* **TLP-RDW**: Install `tlp-rdw` to manage radio devices (Wi-Fi/Bluetooth) automatically.
* **TLPUI**: Optionally install `tlpui` for a graphical editor:

  ```bash
  sudo pacman -S tlpui
  tlpui
  ```

---

## 🧪 Monitoring Tools

* Install sensors and power tools:

  ```bash
  sudo pacman -S lm_sensors powertop cpupower
  sudo sensors-detect
  watch sensors
  ```
* Monitor frequency:

  ```bash
  watch "grep 'MHz' /proc/cpuinfo"
  cpupower frequency-info
  ```

---

## 🧰 Services

Ensure TLP services are enabled:

```bash
sudo systemctl enable tlp.service
sudo systemctl enable tlp-sleep.service
sudo systemctl start tlp.service
```

---

*This config aims to keep your Legion cool and quiet while still responsive. You can adjust AC settings if you need more performance for gaming or compiling.*
