---
title: Embox Quick start
date: "20 january 2019"
---

# Quick Overview
Embox is a real-time operating system for embedded systems.

Embox is a cross-platform operating system. All arch-dependent code is organized as separate modules. It makes porting process to a new platform easy. Currently, Embox supports following architectures: SPARC, Microblaze, ARM, MIPS, PPC, x86, E2k.

Embox is a multitasking operating system and supports different priority levels, preemptive and cooperative multitasking, priority inheritance and different synchronization primitives.

Embox provides POSIX-compatible layer, which allows to use a lot of existing Linux software. For example, Qt embedded, SSH server — Dropbear, PJSIP.

Embox development process is usual and pretty common for all platforms including resources restricted platforms such as MCUs because using a standard toolset. Usually, it's only required to change the architecture dependent part in your configuration file.

Embox has low resources requirement in that designed as modular and configurable project. During configure may be chosen which modules will be in a final image.

Embox allows to create secure systems. Statically building ensures that functionalities weren’t included in the target image couldn’t be executed.

Embox is suitable for Internet Of Things (IoT). It has well TCP/IP stack, a rich set of user software, but at the same time, it has low resource requires.

Embox is suitable for robots. It allows to combine in a one system tasks with rich functionalities and real-time tasks.

# Quick start
It’s better if get started with Embox running one on the qemu emulator, which supported different CPU architectures.

## Getting Embox
clone git repository:
```
    $ git clone https://github.com/embox/embox
```
Or download as an archive [https://github.com/embox/embox/releases](https://github.com/embox/embox/releases)

## Work on Windows or MacOS
The main Embox developer platform is Linux. All descriptions below are given for one. If you have Windows or MacOS it’s better use docker there is a correct environment for starting.
For using:

 * Install docker for your platform.
 * make sure that docker was installed correctly by commands:
```
    $ docker-machine ls
    $ docker-machine start default
```
 * Go to folder with Embox.
 * Launch docker with
```
    $ ./scripts/docker/docker_start.sh
```
 * Execute script
```
    $ . ./scripts/docker/docker_rc.sh
```
to simplify further work. This script create alias with `dr` and `docker run`

And than before each command you should type `dr`. For example:
```
    $ dr make confload-x86/qemu
    $ dr make
    $ dr ./scripts/qemu/auto_qemu
```
For configure and building default template.
After install and check you can miss section Environment Settings and go to section “Build and run on QEMU”

## Enviroment Settings
Minimal required packages are: make, gcc, (cross-compiler for target platform. see "Cross-compiler installation").
Optional packages which recomended to install at once: build-essential gcc-multilib curl libmpc-dev python
For Debian:
```
    $ sudo apt-get install make gcc \
        build-essential gcc-multilib \
        curl libmpc-dev python
```
For Arch:
```
    sudo pacman -S make gcc-multilib cpio qemu
```

## Cross-compiler installation

***x86***:
```
    $ sudo apt-get install gcc
```
It's already installed a package usually. You also required 'gcc-multilib'. You require to install another if you set up the enviroment on Windows or MacOS yourself.

***ARM***:
```
    $ sudo apt install arm-none-eabi-gcc
```
or for Debian:
```
    $ sudo apt install gcc-arm-none-eabi
```
You also can downloaded archive with ARM cross-tools from site [https://launchpad.net/gcc-arm-embedded](https://launchpad.net/gcc-arm-embedded)
Extract the archive and set PATH enviroment variable 
```
    $ export PATH=$PATH:<path to toolchain>/gcc-arm-none-eabi-<version>/bin
```

***SPARC, Microblaze, MIPS, PowerPC, MSP430***:
You can use own cross-compiler based on gcc. But it's better if you make use to our project for installing cross-compiler [https://github.com/embox/crosstool](https://github.com/embox/crosstool). You can use to ready archives from [https://github.com/embox/crosstool/releases](https://github.com/embox/crosstool/releases). Or build demanded cross-compiler with the script from the project
```
    $ ./crosstool.sh ARCH
```
In the result have to appear ***ARCH-elf-toolchain.tar.bz2*** archive. Than you have to extract it and set up 'PATH' enviroment variable.

## QEMU installation
Supported CPU architectures: x86, ARM, MIPS, Sparc, PPC, Microblaze.

Required packages for QEMU for different architectures:
```
    $ sudo apt-get install qemu-system-<ARCH>
```
Where <ARCH>: i386, arm, sparc, mips, ppc or misc (for microblaze).

Notice: QEMU with all supported architectures can be installed with a single command:
```
    $ sudo apt-get install qemu-system
```

## Build and execute on QEMU


