# Quectel Linux USB Driver

Out-of-tree and in-kernel-patch drivers for Quectel cellular modems, organized by Linux kernel LTS version.

## Quick Start

```bash
# 1. Find your kernel version
uname -r    # e.g. 5.15.0-100-generic

# 2. Checkout the matching branch
git clone https://github.com/bacnh85/Quectel_Linux_USB_Driver.git
cd Quectel_Linux_USB_Driver
git checkout v5.15    # use your major.minor version

# 3. Follow the README.md on that branch
```

## Branches

| Branch | Kernel | Quectel Devices | Patch Size |
|--------|--------|----------------|------------|
| `v5.4` | 5.4.x LTS | +30 products | 59 lines |
| `v5.15` | 5.15.x LTS | +25 products | 54 lines |
| `v6.1` | 6.1.x LTS | +21 products | 44 lines |
| `v6.6` | 6.6.x LTS | +7 products | 16 lines |
| `v6.12` | 6.12.x | Full mainline | No patch needed |

## What's in Each Branch

All driver sources are **upstream Linux kernel code** enhanced with Quectel device IDs backported from kernel 6.12.

```
drivers/usb/serial/option.c     ← enhanced with all Quectel USB serial IDs
drivers/usb/serial/usb_wwan.c   ← upstream (no Quectel-specific changes)
drivers/usb/serial/usb-wwan.h   ← upstream header
drivers/net/usb/qmi_wwan.c      ← enhanced with all Quectel QMI IDs
patches/option.c.patch           ← diff: vanilla → enhanced (for in-kernel)
patches/qmi_wwan.c.patch         ← diff: vanilla → enhanced (for in-kernel)
Makefile                         ← out-of-tree module build
```

## Two Build Methods

### Method 1: Out-of-Tree (Recommended)
```bash
make && sudo make install
sudo modprobe option qmi_wwan
```

### Method 2: In-Kernel Patch
```bash
cd /path/to/kernel-source
patch -p1 < /path/to/Quectel_Linux_USB_Driver/patches/option.c.patch
```

## Supported Quectel Modules

**2G/3G:** UC15, UC20
**4G LTE:** EC20, EC21, EC25, EG91, EG95, BG96, BG95, AG35, EP06, EM12, EC200S, EC200T, EC200A, EC200U, EG912Y, EG916Q
**5G NR:** RM500Q, RM520N, RM500K, RM500U, RG650V, EM05G series, EM060K/EM061K series, EM160R-GL

## License

GPL-2.0-only — same as the Linux kernel
