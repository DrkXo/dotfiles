# Basic repair
```bash
sudo ntfsfix /dev/sda5
```
# dry-run
```bash
sudo ntfsfix -n /dev/sda5
```
# clear bad sectors
```bash
sudo ntfsfix -b /dev/sda5
```
# clear dirty flag
```bash
sudo ntfsfix -d /dev/sda5
```
