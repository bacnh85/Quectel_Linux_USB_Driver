# Quectel USB Driver Out-of-Tree Build
#
# This Makefile copies the kernel's own driver sources, applies Quectel
# enhancement patches, and builds the modules out-of-tree.
#
# Usage:
#   make KDIR=/path/to/kernel/source
#   make KDIR=/lib/modules/$(uname -r)/build
#   make install KDIR=/path/to/kernel/source

KDIR ?= /lib/modules/$(shell uname -r)/build

SERIAL_DIR  = drivers/usb/serial
NET_DIR     = drivers/net/usb
BUILD_DIR   = build

.PHONY: all clean install prepare

all: prepare
	$(MAKE) -C $(KDIR) M=$(CURDIR)/$(BUILD_DIR)/serial modules
	$(MAKE) -C $(KDIR) M=$(CURDIR)/$(BUILD_DIR)/net modules

# ── Copy kernel sources and apply patches ────────────────────────────
prepare:
	@echo "Preparing out-of-tree build from kernel $(KDIR)..."
	@mkdir -p $(BUILD_DIR)/serial $(BUILD_DIR)/net

	# ── Serial drivers (option.c + usb_wwan.c) ──
	@if [ -f "$(KDIR)/$(SERIAL_DIR)/option.c" ]; then \
		cp "$(KDIR)/$(SERIAL_DIR)/option.c" "$(BUILD_DIR)/serial/option.c"; \
		cp "$(KDIR)/$(SERIAL_DIR)/usb_wwan.c" "$(BUILD_DIR)/serial/usb_wwan.c"; \
		echo "  ✓ Copied serial sources from kernel"; \
	else \
		echo "  ✗ Serial sources not found in $(KDIR)/$(SERIAL_DIR)/";; \
	fi

	# ── Network driver (qmi_wwan.c) ──
	@if [ -f "$(KDIR)/$(NET_DIR)/qmi_wwan.c" ]; then \
		cp "$(KDIR)/$(NET_DIR)/qmi_wwan.c" "$(BUILD_DIR)/net/qmi_wwan.c"; \
		echo "  ✓ Copied net source from kernel"; \
	else \
		echo "  ✗ qmi_wwan.c not found in $(KDIR)/$(NET_DIR)/";; \
	fi

	# ── Apply Quectel enhancement patches ──
	@if [ -f patches/option.c.patch ] && head -1 patches/option.c.patch | grep -qv "no changes"; then \
		patch -p1 -d $(BUILD_DIR)/serial < patches/option.c.patch && \
		echo "  ✓ Applied option.c enhancements" || \
		echo "  ⚠ option.c patch failed (may already have these IDs)"; \
	fi
	@if [ -f patches/usb_wwan.c.patch ] && head -1 patches/usb_wwan.c.patch | grep -qv "no changes"; then \
		patch -p1 -d $(BUILD_DIR)/serial < patches/usb_wwan.c.patch && \
		echo "  ✓ Applied usb_wwan.c enhancements" || \
		echo "  ⚠ usb_wwan.c patch skipped"; \
	fi
	@if [ -f patches/qmi_wwan.c.patch ] && head -1 patches/qmi_wwan.c.patch | grep -qv "no changes"; then \
		patch -p1 -d $(BUILD_DIR)/net < patches/qmi_wwan.c.patch && \
		echo "  ✓ Applied qmi_wwan.c enhancements" || \
		echo "  ⚠ qmi_wwan.c patch failed (may already have these IDs)"; \
	fi

	# ── Write Kbuild files ──
	@echo 'obj-m += option.o usb_wwan.o' > $(BUILD_DIR)/serial/Kbuild
	@echo 'obj-m += qmi_wwan.o' > $(BUILD_DIR)/net/Kbuild

	@echo "Preparation complete."

install:
	$(MAKE) -C $(KDIR) M=$(CURDIR)/$(BUILD_DIR)/serial modules_install
	$(MAKE) -C $(KDIR) M=$(CURDIR)/$(BUILD_DIR)/net modules_install
	@echo ""
	@echo "Modules installed. Run 'depmod -a' and reload with:"
	@echo "  modprobe -r option usb_wwan qmi_wwan"
	@echo "  modprobe option && modprobe qmi_wwan"

clean:
	rm -rf $(BUILD_DIR)
