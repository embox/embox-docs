---
title: Embox Quick start
date: "20 january 2019"
---

# Quick Overview
Embox is a real-time operating system for embedded systems.

Embox is a cross-platform operating system. All arch-dependent code is organized as separate modules. It makes porting process to a new platform easy. Currently, Embox supports following architectures: ARM, x86, SPARC, Microblaze, MIPS, PPC, E2k.

Embox is a multitasking operating system and supports different priority levels, preemptive and cooperative multitasking, priority inheritance and different synchronization primitives.

Embox provides POSIX-compatible layer, which allows to use a lot of existing Linux software. For example, Qt embedded, SSH server — Dropbear, PJSIP.

Embox development process is usual and pretty common for all platforms including resources restricted platforms such as MCUs because of using standard toolset.

Embox has low resources requirements because it is designed as a modular and configurable project. During the configuration stage, one can choose which modules will be included in the final image.

Embox allows to create secure systems. Statically building ensures that functionalities weren’t included in the target image couldn’t be executed.

Embox is suitable for Internet Of Things (IoT). It has well TCP/IP stack, a rich set of user software, but at the same time, it has low resources requirements.

Embox is suitable for robots. It allows to combine in one system tasks with rich functionalities and real-time tasks. You can create your own POSIX compatible application to control servos, motors, sensors etc., communicating with your robot through a network at the same time.

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
Set up default configuration for desired platform:
```
    $ make confload-<ARCH>/qemu
```
where <ARCH>: x86, arm, mips, ppc, sparc, microblaze.
Example for x86:
```
    make confload-x86/qemu
```
Build Embox:
```
    $ make
```
or for parallel building:
```
    $ make (-jN)
```
Example build on 4 threads:
```
    $ make -j4
```
Execute:
```
    $ ./scripts/qemu/auto_qemu
```
Console output example:
```
Embox kernel start
	unit: initializing embox.kernel.task.task_resource: done
	unit: initializing embox.mem.vmem_alloc: done
```
If all unit-tests where success and all modules loaded, command prompt will appear and you can type and execute commands included in the configuration. You can start with ***'help'*** which print enabled commands list.

For exit press ***ctrl+’A’*** and than ***‘x’***.

## Paticulars of Mybuild build system
Embox - modular and configurable. Declarative program language Mybuild has been developed for this features. Mybuild allows to describe both single modules and whole target system.
A module is a base concept for build system. The module description contains: source files list, options which can be set for the module during configuration and dependences list.
The configuration is a paticular description of whole system. It contains: required list module, set up modules options and build rules (cross-compiler, additional compiler flags, memory map etc.). Graph of system desing base on the configuration and module descriptions and than generate different build artifacts: linker scripts, makefiles, headers. It's not necesary to point all modules, they will enabled by dependences list from module descriptions.

Current configuration locates in ***conf/*** folder. It can be set up with
```
    $ make confload-<CONF_NAME>
```
For example, for set up demo canfiguration for executing qemu-arm you should 
```
    $ make confload-arm/qemu
```.

Use 
```
    $ make confload
```
to show of ready configurations list.

After set up current configuration you can change feaches for your requiments. It's enouph to add string ***include <PACKAGE_NAME><MODULE_NAME>*** to ***conf/mods.conf*** file to enable some of missed application. Example, to enable ***`help`*** command you have to add ***include embox.cmd.help***

# "Hello word" application
Embox application is an Embox module, which description contains attributes shown that the module is an executable application. Source code Embox application is usual C-code and can be compiled under Linux.

## Creation and Execution
To add own simplest application "Hello world" you have to do follow:

* Create folder *hello_world* in *src/cmds*:

```
     $ mkdir src/cmds/hello_world
```
* Create source file *src/cmds/hello_world/hello_world.c* contains follow:

```
     #include <stdio.h>

     int main(int argc, char **argv) {
          printf("Hello, world!\n");
     }
```

* Create file with module description *src/cmds/hello_world/Mybuild*:

```
     package embox.cmd

     @AutoCmd
     @Cmd(name = "hello_world", help=”First Embox application”)
     module hello_world {
     	source "hello_world.c"
     }
```

* Add to file configuration *conf/mods.conf* follow string:

```
     include embox.cmd.hello_world
```

* Build Embox:

```
     $ make
```

 * Execute Embox:

```
     $ ./scripts/qemu/auto_qemu
```

 * Type ***help*** in appeared console to check there is ***hello_world*** in the command list. Execute it typing ***hello_world*** in console. You message printing with *printf* must be appeared.

```
     root@embox:/#hello_world
     Hello, world!
     root@embox:/#
```

## File module descriptions
Parse Mybuild file from "Hello world" example:

```
     package embox.cmd

     @AutoCmd
     @Cmd(name = "hello_world", help=”First Embox application”)
     module hello_world {
     	source "hello_world.c"
     }
```

The first line contains package name ***embox.cmd***. In Embox all modules are distributed to packages. Full module name consist of package name and module name. Module name is defined in string ***module hello_world***.
