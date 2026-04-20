# Quectel USB Driver Enhancements — Linux 5.4

This branch contains out-of-tree build support and in-kernel patches for adding
**comprehensive Quectel modem support** to Linux kernel **5.4**.

## Supported Devices

Enhanced support for 30+ Quectel modem modules including:
- **EC Series**: EC200A, EC200S, EC200T, EC200U, EC25, EC21
- **EG Series**: EG91, EG95, EG912Y, EG916Q
- **EM Series**: EM05 (all variants), EM06, EM12, EM060K, EM061K
- **RM Series**: RM500Q, RM500K, RM520N, RM500U
- **RG Series**: RG650V
- **BG Series**: BG95, BG96

## Quick Start

### Out-of-Tree Build (Recommended)

```bash
# Build against running kernel headers
make KDIR=/lib/modules/$(uname -r)/build

# Or against full kernel source tree
make KDIR=/path/to/linux-5.4

# Install the modules
sudo make install KDIR=/lib/modules/$(uname -r)/build
sudo depmod -a
```

### In-Kernel Patch

```bash
# Apply patches directly to your kernel source tree
cd /path/to/linux-5.4
patch -p1 < /path/to/this/repo/patches/option.c.patch
patch -p1 < /path/to/this/repo/patches/qmi_wwan.c.patch

# Then build and install as usual
make modules_install
```

## Files

| File | Description |
|------|-------------|
| `Makefile` | Out-of-tree build system |
| `patches/option.c.patch` | Quectel USB serial device IDs |
| `patches/qmi_wwan.c.patch` | Quectel QMI network device IDs |

## Branch Structure

| Branch | Kernel Version |
|--------|---------------|
| `v5.4` | Linux 5.4 LTS |
| `v5.15` | Linux 5.15 LTS |
| `v6.1` | Linux 6.1 LTS |
| `v6.6` | Linux 6.6 LTS |
| `v6.12` | Linux 6.12 (reference) |

Switch to the branch matching your kernel version:
```bash
git checkout v5.4
```
