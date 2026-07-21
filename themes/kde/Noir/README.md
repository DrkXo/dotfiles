# Noir KDE Theme

A dark KDE Plasma desktop theme.

## Components

- **Plasma Desktop Theme** - Dark panel backgrounds, widgets, and UI elements
- **Color Scheme** - Matching system-wide color palette
- **Konsole Color Scheme** - Terminal color scheme
- **Aurorae Window Decoration** - Window title bar and border decoration
- **Look and Feel** - Complete desktop look and feel package
- **Splash Screen** - Startup splash screen

## Installation

Run the install script:

```bash
./install.sh
```

## Uninstallation

Run the uninstall script:

```bash
./uninstall.sh
```

## Manual Installation

Copy the following to `~/.local/share/`:

- `color-schemes/Noir.colors` -> `~/.local/share/color-schemes/`
- `konsole/Noir.colorscheme` -> `~/.local/share/konsole/`
- `plasma/desktoptheme/Noir/` -> `~/.local/share/plasma/desktoptheme/`
- `plasma/look-and-feel/Noir/` -> `~/.local/share/plasma/look-and-feel/`
- `plasma/splash/Noir/` -> `~/.local/share/plasma/splash/`
- `aurorae/Noir/` -> `~/.local/share/aurorae/`

Then apply via System Settings > Appearance > Global Theme.

## License

LGPL
