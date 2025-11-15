# 🐧 Fix GTK Icon & WebKit2 Crashes on Arch Linux (Post Cambalache / XDG Issues)

## 🧵 Background

After experimenting with **Cambalache** (Glade replacement) and dealing with rolling updates, you might face persistent GTK/WebKit2 issues:

- Icon load failures like:  
  `Failed to load ...icon.png: Unrecognized image file format (gdk-pixbuf-error-quark, 3)`
- GTK apps or AppImages crash or display without icons.
- WebKit2 apps fail to load websites or perform network activity.
- Builds fail or crash at runtime for GTK/WebKit2 projects.

## ✅ Solution for Arch Linux

### 1. **Fix `XDG_DATA_DIRS` (Set Globally)**

Misconfigured `XDG_DATA_DIRS` can break icon and theme loading, especially in AppImages and GUI launchers.

#### ➤ Temporary fix (for terminal session only):

```bash
export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/usr/local/share:$HOME/.local/share
```

#### ➤ Permanent fix (global):

Edit or create this file:
```bash
sudo nano /etc/environment
```

Add or fix the line:
```ini
XDG_DATA_DIRS=/usr/local/share:/usr/share:$HOME/.local/share
```

> ⚠️ Don't include `$XDG_DATA_DIRS` in `/etc/environment` — it won't be expanded. List paths directly.

Then **reboot** to apply globally (so GUI launchers, AppImages, and desktop sessions see the variable).

---

### 2. **Fix MIME Types and Pixbuf Cache**

```bash
sudo update-mime-database /usr/share/mime
sudo pacman -Syu shared-mime-info gdk-pixbuf2
gdk-pixbuf-query-loaders --update-cache
```

> `gdk-pixbuf-query-loaders` is located in `/usr/bin/` on Arch, so no need for full path.

---

### 3. **Reinstall GDK Pixbuf (Just in Case)**

```bash
sudo pacman -Syu gdk-pixbuf2
```

> On Arch, dev headers are usually bundled — no need for separate `-dev` packages like in Debian.

---

### 4. **Apply Changes**

To ensure everything is loaded:
```bash
source ~/.bashrc
```

Or **reboot** to load `/etc/environment` changes system-wide — essential for GUI applications and AppImages.

---

## 🎉 Result

GTK apps and AppImages should now:

- Load icons and themes correctly
- Render WebKit2 content (webviews, URIs)
- Avoid runtime crashes caused by missing loaders/mime types
