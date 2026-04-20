# Quectel USB Driver Enhancements — Linux 6.6

Out-of-tree build support and in-kernel patches for comprehensive Quectel
modem support on Linux kernel **6.6**.

## Supported Devices

EC200(A/S/T/U), EC25, EC21, EG91, EG95, EG912Y, EG916Q, EM05 (all variants),
EM06, EM12, EM060K, EM061K, RM500Q, RM500K, RM520N, RM500U, RG650V, BG95, BG96

## Quick Start

### Out-of-Tree Build (Recommended)

```bash
make KDIR=/lib/modules/$(uname -r)/build
sudo make install
sudo depmod -a
```

### In-Kernel Patch

```bash
cd /path/to/linux-6.6
patch -p1 < patches/option.c.patch
patch -p1 < patches/qmi_wwan.c.patch
```

## Files

| File | Description |
|------|-------------|
| `Makefile` | Out-of-tree build: copies from kernel, patches, builds |
| `patches/option.c.patch` | USB serial device IDs for Quectel modems |
| `patches/qmi_wwan.c.patch` | QMI network device IDs for Quectel modems |

## Branches

| Branch | Kernel |
|--------|--------|
| `v5.4` | 5.4 LTS |
| `v5.15` | 5.15 LTS |
| `v6.1` | 6.1 LTS |
| `v6.6` | 6.6 LTS |
| `v6.12` | 6.12 |
