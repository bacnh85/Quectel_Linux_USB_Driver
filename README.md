# Introduction

Quectel USB Serial Driver for UCxx/EC2x/EGxx/EP06/EM06/BG96/AG35.

As I am working in Quectel as an FAE for Vietnam and South East Asia, we will try our best to support all world wide customers.

# Prepare

Ubuntu 16.04 running kernel 4.15.0-43-generic.

```
$ uname -a
Linux ubuntu 4.15.0-43-generic #46~16.04.1-Ubuntu SMP Fri Dec 7 13:31:08 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

```

Download Ubuntu linux headers:

```
$ sudo apt-get install linux-headers-$(uname -r)
```

the Linux headers will be located in /usr/src/

# Compile/Install

```
$ git clone git@github.com:ngohaibac/Quectel_USB_Serial_Driver.git
$ cd Quectel_USB_Serial_Driver/4.15.0
$ make 
$ sudo make install
```

# Credit

This guide and kernel driver is based on Quectel Driver User Guide V1.8 by Quectel Wirreless Solutions.