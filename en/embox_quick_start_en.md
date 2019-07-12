
# Quick start
It’s better to get started with Embox running on QEMU emulator, which supports different CPU architectures.

## Getting Embox
Clone git repository:
```
    $ git clone https://github.com/embox/embox
```
Or download as an archive [https://github.com/embox/embox/releases](https://github.com/embox/embox/releases)

## Work on Windows or MacOS
The main Embox development platform is Linux, so all descriptions below are given for Linux. If you are using Windows or MacOS, it’s better to use Docker with already installed environment for starting. You can start using our Docker (emdocker) in the following way:

 * Install docker for your OS.
 * Make sure docker was installed correctly:
```
    $ docker-machine ls
    $ docker-machine start default
```
 * Go to Embox root folder.
 * Launch docker:
```
    $ ./scripts/docker/docker_start.sh
```
 * Source the script:
```
    $ . ./scripts/docker/docker_rc.sh
```
to simplify further work. Roughly speaking, this script mainly creates an alias between `dr` and `docker run`.

And than you should prepend every command with `dr` to execute it inside the docker container. For example:
```
    $ dr make confload-x86/qemu
    $ dr make
    $ dr ./scripts/qemu/auto_qemu
```
to configure and build default template for x86.

After docker installation you can skip the section "Environment Settings" below and go directly to the section “Build and run on QEMU”.

## Enviroment Settings
Minimal required packages: *make*, *gcc*, (cross-compiler for target platform. see "Cross-compiler installation").
Optional packages which are recomended to install at once: *build-essential*, *gcc-multilib*, *curl*, *libmpc-dev*, *python*.

For Debian/Ubuntu:
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
Usually, these packages are already installed for your OS. You are also required to install `gcc-multilib`.
Please note, it's required to install another packages if you already set up the environment on Windows or MacOS by yourself.

***ARM***:
```
    $ sudo apt install arm-none-eabi-gcc
```
or for Debian:
```
    $ sudo apt install gcc-arm-none-eabi
```
You can also download the archive with ARM cross-tools from [https://launchpad.net/gcc-arm-embedded](https://launchpad.net/gcc-arm-embedded)
Extract files from archive and set *PATH* enviroment variable:
```
    $ export PATH=$PATH:<path to toolchain>/gcc-arm-none-eabi-<version>/bin
```

***SPARC, Microblaze, MIPS, PowerPC, MSP430***:
You can try to use some cross-compiler based on gcc in case if you already have a suitable one.
But it would be better if you will use our project for cross-compiler installation [https://github.com/embox/crosstool](https://github.com/embox/crosstool).
You can use already ready-to-use archives from [https://github.com/embox/crosstool/releases](https://github.com/embox/crosstool/releases). Or you can build cross-compiler with the script in the project's root folder:
```
    $ ./crosstool.sh ARCH
```
As the result ***ARCH-elf-toolchain.tar.bz2*** archive will be created. Than you need to extract files from the archive and set up 'PATH' enviroment variable.

## QEMU installation
Supported CPU architectures: x86, ARM, MIPS, Sparc, PPC, Microblaze.

QEMU can be installed in the following way:
```
    $ sudo apt-get install qemu-system-<ARCH>
```
Where <ARCH>: i386, arm, sparc, mips, ppc or misc (for microblaze).

Notice: QEMU packages for all supported architectures can be installed with a single command:
```
    $ sudo apt-get install qemu-system
```

## Build and run on QEMU
Set up default configuration for the desired platform:
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
    $ make -jN
```
Example of how to build with 4 parallel jobs:
```
    $ make -j4
```

Now you are able to run Embox:
```
    $ ./scripts/qemu/auto_qemu
```
Console output example:
```
Embox kernel start
	unit: initializing embox.kernel.task.task_resource: done
	unit: initializing embox.mem.vmem_alloc: done
```
If all unit tests passed successfully and all modules loaded, then command prompt will appear.
Now you can execute commands included in the configuration (`mods.conf`). You can start with ***help*** command which prints list of available commands.

Press ***ctrl+’A’*** and then '***x***' to exit from Qemu.

## Preliminaries to Mybuild build system
Embox is modular and configurable. Declarative program language Mybuild has been developed for these features. Mybuild allows to describe both single modules and whole target system.
A module is a base concept for build system. A module description contains: source files list, options which can be set for the module during configuration, and dependences list.
The configuration is a particular description of the whole system. It contains list of required modules, modules options and build rules (cross-compiler, additional compiler flags, memory map etc.).
Graph of the system will be based on the configuration and modules descriptions.
Build system then generates different build artifacts: linker scripts, makefiles, headers.
It's not necesary to include all modules, they will be enabled using dependencies for each module included in the initial configuration list.

Current configuration locates in ***conf/*** folder. It can be set up with:
```
    $ make confload-<CONF_NAME>
```
For example, to set up demo configuration for qemu-arm you should do the following:
```
    $ make confload-arm/qemu
```

Use 
```
    $ make confload
```
to get the list of all possible configurations.

After you set up some configuration you can tune configuration due to your requirements.
You can add ***include \<PACKAGE_NAME\>\<MODULE_NAME\>*** to your ***conf/mods.conf*** file to enable additional application.
For example, add ***include embox.cmd.help*** to enable ***`help`*** command.

## "Hello world" application
Embox application is an usual Embox module with special attributes. These attributes declare your module as an executable application.
Source code of Embox application is usual POSIX program written in C, and so can be compiled under Linux too.

### Creation and Execution
To add your own simplest application "Hello world" you can do the following:

* Create folder *hello_world* in *src/cmds*:

```
     $ mkdir src/cmds/hello_world
```
* Create *src/cmds/hello_world/hello_world.c*:

```
     #include <stdio.h>

     int main(int argc, char **argv) {
          printf("Hello, world!\n");
     }
```

* Create file *src/cmds/hello_world/Mybuild* with your module description:

```
     package embox.cmd

     @AutoCmd
     @Cmd(name = "hello_world", help=”First Embox application”)
     module hello_world {
     	source "hello_world.c"
     }
```

* Now add the application into your configuration *conf/mods.conf*:

```
     include embox.cmd.hello_world
```

* Build Embox:

```
     $ make
```

 * Run Embox:

```
     $ ./scripts/qemu/auto_qemu
```

 * Type ***help*** in Embox console to check if there is ***hello_world*** in commands list. Execute ***hello_world*** command and you will see:

```
     root@embox:/#hello_world
     Hello, world!
     root@embox:/#
```

### Mybuild file for "Hello World"
Let's look at the Mybuild file from "Hello world" example in more details:

```
     package embox.cmd

     @AutoCmd
     @Cmd(name = "hello_world", help=”First Embox application”)
     module hello_world {
     	source "hello_world.c"
     }
```

The first line contains package name ***embox.cmd***. In Embox all modules are organized into packages.
Full module name consist of the corresponding package name appended with module name. Module name is defined in string ***module hello_world***.

### Debugging
You can use the same script with *-s -S -no-kvm* flags for debugging:
```
$ sudo ./scripts/qemu/auto_qemu -s -S -no-kvm
```
After running that QEMU waits for a connection from a gdb-client. Run gdb in the other terminal:
```
$ gdb ./build/base/bin/embox
...
(gdb) target extended-remote :1234
(gdb) continue
```
The system starts to load.

At any moment in gdb terminal you can type <kbd>ctrl + C</kbd> and see the stack of the current thread (`backtrace`) or set breakpoints (`break <function name>`, `break <file name>:<line number>`).
