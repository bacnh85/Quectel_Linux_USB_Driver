# Quectel USB Drivers — Linux 6.6.x

Out-of-tree and in-kernel-patch Quectel cellular modem drivers for Linux kernel **6.6.x**.

## Supported Modules

| Module | Product ID | Type |
|--------|-----------|------|
| UC15 | 0x9090 | 2G/3G |
| UC20 | 0x9003 | 3G |
| EC20 (MDM9215) | 0x9215 | 4G LTE |
| EC21 | 0x0121 | 4G LTE |
| EC25 / EC20 R2.0 | 0x0125 | 4G LTE |
| EG91 | 0x0191 | 4G LTE |
| EG95 | 0x0195 | 4G LTE |
| BG96 | 0x0296 | 4G Cat-M/NB-IoT |
| AG35 | 0x0435 | Automotive |
| EP06 / EG06 / EM06 | 0x0306 | 4G LTE |
| EM05G series | 0x030a+ | 5G NR |
| EM060K / EM061K series | 0x030b+ | 5G NR |
| EM12 / EG12 / EM16 | 0x0512 | 4G LTE |
| EM160R-GL | 0x0620 | 5G NR |
| BG95 | 0x0700 | Cat-M/NB-IoT |
| RM500Q-GL | 0x0800 | 5G NR Sub-6 |
| RM520N | 0x0801 | 5G NR mmWave |
| RM500U-CN | 0x0900 | 5G NR |
| RG650V | 0x0122 | 5G NR |
| EC200S-CN | 0x6002 | 4G LTE |
| EC200A | 0x6005 | 4G LTE |
| EC200T | 0x6026 | 4G LTE |
| EC200U | 0x0901 | 4G LTE |
| RM500K | 0x7001 | 5G NR |
| EG912Y | 0x6001 | 4G LTE |
| EG916Q | 0x6007 | 4G LTE |

> **Note:** Not all products above are new in this branch — the in-kernel patches add the ones missing from kernel 6.6.x mainline. See `patches/*.patch` for the exact delta.

---

## Method 1: Out-of-Tree Module Build (Recommended)

Build driver modules against your running kernel headers **without modifying** the kernel source tree.

### Prerequisites

```bash
# Debian/Ubuntu
sudo apt install build-essential linux-headers-$(uname -r)

# RHEL/CentOS/Fedora
sudo dnf install gcc make kernel-devel-$(uname -r)

# Arch Linux
sudo pacman -S base-devel linux-headers
```

### Build & Install

```bash
# Clone and checkout this branch
git clone -b v6.6 https://github.com/bacnh85/Quectel_Linux_USB_Driver.git
cd Quectel_Linux_USB_Driver

# Build against current kernel
make

# Or build against a specific kernel tree
# make KDIR=/lib/modules/5.15.0-custom/build

# Install modules
sudo make install

# Load modules
sudo modprobe option
sudo modprobe qmi_wwan_q

# Verify
lsmod | grep -E 'option|qmi_wwan'
dmesg | grep -i quectel
```

### What Gets Built

| Module | Purpose |
|--------|---------|
| `option.ko` | USB serial driver for AT port / modem data |
| `usb_wwan.ko` | USB WWAN broadband serial helper |
| `qmi_wwan_q.ko` | QMI network driver with QMAP multiplexing support |

### Uninstall

```bash
sudo rmmod qmi_wwan_q option usb_wwan
sudo make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/usb/serial clean
sudo make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/usb clean
# Remove from /lib/modules/$(uname -r)/extra/ if installed there
sudo depmod -a
```

---

## Method 2: In-Kernel Patch

Apply patches to your kernel source tree to add Quectel device support directly into the built-in drivers.

> **Use this when:** You are building a custom kernel or BSP and want Quectel support included natively.

### Apply Patches

```bash
# From your kernel source tree root
cd /path/to/linux-kernel-source

# Apply the serial driver patch (adds Quectel USB serial device IDs)
patch -p1 < /path/to/Quectel_Linux_USB_Driver/patches/option.c.patch

# Apply the QMI WWAN patch (adds Quectel QMI network device IDs)
patch -p1 < /path/to/Quectel_Linux_USB_Driver/patches/qmi_wwan.c.patch
```

### Verify Patches Applied

```bash
# Check Quectel device count in option.c
grep -c "QUECTEL_PRODUCT" drivers/usb/serial/option.c

# Check Quectel entries in qmi_wwan.c
grep -c "0x2c7c\|0x2C7C" drivers/net/usb/qmi_wwan.c
```

### Build Kernel Modules

```bash
# Build only the affected modules (faster)
make drivers/usb/serial/option.ko
make drivers/net/usb/qmi_wwan.ko

# Or build the full kernel
make -j$(nproc)
```

### Important Notes

- The in-kernel patches **only add device IDs and quirks** to the existing `option` and `qmi_wwan` drivers — they do not replace them.
- For **QMAP multiplexing** (multiple PDN sessions), you still need the out-of-tree `qmi_wwan_q.ko` module from Method 1 — mainline `qmi_wwan` does not support QMAP.
- Patches are generated against vanilla kernel 6.6.x sources. If your kernel is already patched (e.g., vendor BSP), you may need to resolve conflicts manually.

---

## Troubleshooting

### Device not detected

```bash
# Check USB device enumeration
lsusb | grep -i quectel
# or
usb-devices | grep -A5 "Vendor=2c7c"

# Check if modules are loaded
lsmod | grep -E 'option|usb_wwan|qmi_wwan'

# Check kernel messages
dmesg | tail -50
```

### Modem appears but no network

```bash
# Check QMI device
ls -la /dev/cdc-wdm*
# or
ip link show | grep -i wwan

# Check quectel-CM or uqmi connectivity
quectel-CM -s your_apn
```

### Module build errors

- Ensure `linux-headers` matches your running kernel exactly
- For older kernels (< 5.4), additional compat headers may be needed
- The out-of-tree sources include version compatibility for kernels 3.x through 6.x+

## License

GPL-2.0-only
