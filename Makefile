# Quectel USB Driver - Out-of-tree build for Linux 5.4.x
#
# Quick build:
#   make                        # build against current kernel headers
#   make KDIR=/path/to/kernel   # build against specific kernel tree
#   make install                # install modules
#   make clean

KDIR ?= /lib/modules/$(shell uname -r)/build
MKBUILD := $(PWD)

.PHONY: all modules install clean

all: modules

modules:
	$(MAKE) -C $(KDIR) M=$(MKBUILD)/drivers/usb/serial modules
	$(MAKE) -C $(KDIR) M=$(MKBUILD)/drivers/net/usb modules

install:
	$(MAKE) -C $(KDIR) M=$(MKBUILD)/drivers/usb/serial modules_install
	$(MAKE) -C $(KDIR) M=$(MKBUILD)/drivers/net/usb modules_install
	-depmod -a

clean:
	$(MAKE) -C $(KDIR) M=$(MKBUILD)/drivers/usb/serial clean
	$(MAKE) -C $(KDIR) M=$(MKBUILD)/drivers/net/usb clean
