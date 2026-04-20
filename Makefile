# Quectel USB Driver Out-of-Tree Build
#
# Copies your kernel's own upstream driver sources, applies Quectel
# enhancement patches (additional device IDs), and builds the modules.
#
# Usage:
#   make                          # uses running kernel headers
#   make KDIR=/path/to/kernel     # uses specified kernel source
#   make install                  # install built modules

KDIR ?= /lib/modules/$(shell uname -r)/build
BUILD_DIR := build
KBUILD_MODPOST_WARN ?= 1

SERIAL_SRC := $(KDIR)/drivers/usb/serial
NET_SRC    := $(KDIR)/drivers/net/usb

.PHONY: all clean install

all: prepare
	$(MAKE) -C $(KDIR) M=$(CURDIR)/$(BUILD_DIR)/serial KBUILD_MODPOST_WARN=$(KBUILD_MODPOST_WARN) modules
	$(MAKE) -C $(KDIR) M=$(CURDIR)/$(BUILD_DIR)/net KBUILD_MODPOST_WARN=$(KBUILD_MODPOST_WARN) modules

prepare:
	@echo "=== Quectel USB Driver Out-of-Tree Build ==="
	@mkdir -p $(BUILD_DIR)/serial $(BUILD_DIR)/net
	@# Copy upstream sources from kernel tree
	@test -f "$(SERIAL_SRC)/option.c" && cp "$(SERIAL_SRC)/option.c" "$(BUILD_DIR)/serial/option.c" || echo "WARN: option.c not found"
	@test -f "$(SERIAL_SRC)/usb_wwan.c" && cp "$(SERIAL_SRC)/usb_wwan.c" "$(BUILD_DIR)/serial/usb_wwan.c" || echo "WARN: usb_wwan.c not found"
	@test -f "$(SERIAL_SRC)/usb-wwan.h" && cp "$(SERIAL_SRC)/usb-wwan.h" "$(BUILD_DIR)/serial/usb-wwan.h" || echo "WARN: usb-wwan.h not found"
	@test -f "$(NET_SRC)/qmi_wwan.c" && cp "$(NET_SRC)/qmi_wwan.c" "$(BUILD_DIR)/net/qmi_wwan.c" || echo "WARN: qmi_wwan.c not found"
	@# Apply Quectel enhancement patches for build/ layout
	@if [ -f patches/option.c.patch ] && ! head -1 patches/option.c.patch | grep -q "No changes"; then 		patch -p4 -d $(BUILD_DIR)/serial < patches/option.c.patch || echo "NOTE: option.c patch may conflict"; 	fi
	@if [ -f patches/qmi_wwan.c.patch ] && ! head -1 patches/qmi_wwan.c.patch | grep -q "No changes"; then 		patch -p4 -d $(BUILD_DIR)/net < patches/qmi_wwan.c.patch || echo "NOTE: qmi_wwan.c patch may conflict"; 	fi
	@# Write Kbuild files
	@echo 'obj-m += option.o usb_wwan.o' > $(BUILD_DIR)/serial/Kbuild
	@echo 'obj-m += qmi_wwan.o' > $(BUILD_DIR)/net/Kbuild
	@echo "Sources prepared. Building..."

install:
	$(MAKE) -C $(KDIR) M=$(CURDIR)/$(BUILD_DIR)/serial KBUILD_MODPOST_WARN=$(KBUILD_MODPOST_WARN) modules_install
	$(MAKE) -C $(KDIR) M=$(CURDIR)/$(BUILD_DIR)/net KBUILD_MODPOST_WARN=$(KBUILD_MODPOST_WARN) modules_install
	@echo "Done. Run: depmod -a && modprobe -r option qmi_wwan && modprobe option && modprobe qmi_wwan"

clean:
	rm -rf $(BUILD_DIR)
