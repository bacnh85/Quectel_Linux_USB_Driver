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

## Supported Branches

| Branch | Kernel | Option Devices | QMI Devices | Status |
|--------|--------|---------------|-------------|--------|
| `v5.4` | 5.4.x LTS | 14 products | 12 entries | Legacy (Ubuntu 20.04) |
| `v5.15` | 5.15.x LTS | 14 products | 16 entries | Maintained |
| `v6.1` | 6.1.x LTS | 17 products | 18 entries | Maintained |
| `v6.6` | 6.6.x LTS | 33 products | 18 entries | Current LTS |
| `v6.12` | 6.12.x | 39 products | 19 entries | Latest |

## Two Build Methods

Each branch supports two installation methods:

### Method 1: Out-of-Tree Module Build (Recommended)
Build and install driver modules without modifying your kernel source.
See the branch-specific README for details.

### Method 2: In-Kernel Patch
Apply patches to your kernel source tree to permanently add Quectel support.
Patch files are in the `patches/` directory on each branch.

## Supported Quectel Modules

- **2G/3G:** UC15, UC20
- **4G LTE:** EC20, EC21, EC25, EG91, EG95, BG96, AG35, EP06, EM12, EC200S, EC200T, EC200A, EC200U
- **5G NR:** RM500Q, RM520N, RM500K, RG650V, EM05G series, EM060K/EM061K series

## Device IDs (Vendor: 0x2C7C)

The full list of Quectel USB device IDs is maintained in:
- `drivers/usb/serial/option.c` — serial port (AT/modem) support
- `drivers/net/usb/qmi_wwan_q.c` — QMI network + QMAP multiplexing
- `patches/*.patch` — diffs for in-kernel integration

## Source Attribution

- **Out-of-tree drivers** are based on [QuectelWB/q_drivers](https://github.com/QuectelWB/q_drivers) with kernel version compatibility (3.x – 6.x+)
- **In-kernel patches** are backported from mainline Linux 6.12 to older LTS kernels
- Both are GPL-2.0 licensed

## License

GPL-2.0-only — same as the Linux kernel
