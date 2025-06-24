
# Dolphin Service Menu: Run `.exe` with Wine + MangoHud + GOverlay

This guide helps you create a Dolphin service menu entry that allows you to run `.exe` files using Wine with the MangoHud performance overlay, and optionally launch GOverlay.

---

## 🛠️ Step 1: Create the Service Menu File

Create the following file:

```bash
mkdir -p ~/.local/share/kio/servicemenus
kate ~/.local/share/kio/servicemenus/run_with_mangohud.desktop
```

Replace `kate` with your preferred text editor if needed.

---

## ✍️ Step 2: Add the Following Content

Paste this content into the file:

```ini
[Desktop Entry]
Type=Service
ServiceTypes=KonqPopupMenu/Plugin
MimeType=application/x-ms-dos-executable;application/x-msdownload
Actions=RunWithMangoHud;RunWithMangoHudGOverlay;
X-KDE-Priority=TopLevel
Icon=wine

[Desktop Action RunWithMangoHud]
Name=Run with Wine + MangoHud
Icon=wine
Exec=env MANGOHUD=1 wine "%f"

[Desktop Action RunWithMangoHudGOverlay]
Name=Run with Wine + MangoHud + GOverlay
Icon=wine
Exec=sh -c 'goverlay & env MANGOHUD=1 wine "%f"'
```

---

## ✅ Step 3: Make the File Executable

```bash
chmod +x ~/.local/share/kio/servicemenus/run_with_mangohud.desktop
```

---

## 🔄 Step 4: Restart Dolphin

```bash
kquitapp5 dolphin && dolphin &
```

---

## 🧪 Step 5: Test the Service Menu

Right-click on any `.exe` file in Dolphin. You should see:

- **Run with Wine + MangoHud**
- **Run with Wine + MangoHud + GOverlay**

---

## 📝 Notes

- **MangoHud**: Ensure MangoHud is installed and works (`mangohud glxgears` or `mangohud vkcube`).
- **GOverlay**: Should be installed and accessible via `goverlay`.
- **Wine**: Required for running `.exe` files.
- **MIME Types**: Targeted at `.exe` file types.

---

Enjoy monitoring your Windows programs with performance metrics directly from Dolphin!
