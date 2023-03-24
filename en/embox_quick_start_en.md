# Quick start
It’s better to get started with Embox running on QEMU emulator, which supports different CPU architectures.

## Getting Embox
Clone git repository:
```
    $ git clone https://github.com/embox/embox
```
Or download as an archive [https://github.com/embox/embox/releases](https://github.com/embox/embox/releases).

## Work on Windows or MacOS
### Please follow the next recommendations:
Download an actual version of PowerShell:

[How to download PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3/)

Open PowerShell as an administrator and install WSL2 (please pay your attention to the demands on Windows version):

[How to install WSL2](https://learn.microsoft.com/en-us/windows/wsl/install-manual)
```
    Before the next step upgrade WSL1 to WSL2 if you did'nt do this(the instruction is in a link above).
    In other way Embox won't run on Windows.
```

### Download Ubuntu from Microsoft Store
Check yout version of WSL the next way: insert the command below in PowerShell:
```
    wsl -l -v
```
Run the commands below in command line of Ubuntu for installing necessary programs:
```
    sudo apt-get update
    sudo apt-get install unzip
    sudo apt-get install make
    sudo apt-get install gcc
    sudo apt-get install gcc-10-multilib
    sudo apt-get install qemu-system-x86
    sudo apt-get install python3
    sudo apt-get install python-is-python3
```
Clone version of embox to yourself(use https or ssh):
```
    git clone <https://github.com/embox/embox.git>
    git clone <git@github.com:embox/embox.git>
```

Open the directory of the embox project
```
    cd embox
```
Run the next three commands
```
    make confload-x86/qemu
    make
    ./scripts/qemu/auto_qemu
```
P.S.: If you have any problems with running Embox on Windows -- please check a correctness of the inserted commands.
If it's correct -- you can use the recommendations from the article(the link is below):

[How to solve problems with WSL](https://learn.microsoft.com/en-us/windows/wsl/troubleshooting)


## Enviroment Settings
Minimal required packages: *make*, *gcc*, (cross-compiler for target platform. see "Cross-compiler installation").
Optional packages, which are recomended to install at once: *build-essential*, *gcc-multilib*, *curl*, *libmpc-dev*, *python*.

For Debian/Ubuntu:
```
    $ sudo apt-get install make gcc \
        build-essential gcc-multilib \
        curl libmpc-dev python
```
For Arch:
```
    $ sudo pacman -S make gcc-multilib cpio qemu
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
You can also download the archive with ARM cross-tools from [https://launchpad.net/gcc-arm-embedded](https://launchpad.net/gcc-arm-embedded).
Extract files from archive and set *PATH* enviroment variable:
```
    $ export PATH=$PATH:<path to toolchain>/gcc-arm-none-eabi-<version>/bin
```

***SPARC, Microblaze, MIPS, PowerPC, MSP430***:
You can try to use some cross-compiler based on gcc in case if you already have a suitable one.

But it would be better if you will use our project for cross-compiler installation:
[https://github.com/embox/crosstool](https://github.com/embox/crosstool)

You can use already ready-to-use archives from:
[https://github.com/embox/crosstool/releases](https://github.com/embox/crosstool/releases)

Or you can build cross-compiler with the script in the project's root folder:
```
    $ ./crosstool.sh ARCH
```
As the result ***ARCH-elf-toolchain.tar.bz2*** archive will be created. Than you need to extract files from the archive and set up `PATH` enviroment variable.

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
or for parallel building with N parallel jobs:
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

Press ***ctrl+’A’*** and then `***x***` to exit from Qemu.

## Preliminaries to Mybuild build system
Embox is modular and configurable. Declarative program language "Mybuild" has been developed for these features. 
Mybuild allows to describe both single modules and whole target system.

A module is a base concept for build system. A module description contains: source files list, options which can be set for the module during configuration, and dependences list.

The configuration is a particular description of the whole system. It contains list of required modules, modules options and build rules (cross-compiler, additional compiler flags, memory map etc.).

Graph of the system will be based on the configuration and modules descriptions.
Build system, that generates different build artifacts: linker scripts, makefiles, headers.
It's not necesary to include all modules, they will be enabled using dependencies for each module included in the initial configuration list.

Current configuration locates in ***conf/*** folder. It can be set up with:
```
    $ make confload-<CONF_NAME>
```
For example, to set up demo configuration for qemu-arm you should do the following:
```
    $ make confload-arm/qemu
```
Use: 
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
     @Cmd(name = "hello_world", help="First Embox application")
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
     @Cmd(name = "hello_world", help="First Embox application")
     module hello_world {
     	source "hello_world.c"
     }
```
The first line contains package name ***embox.cmd***. In Embox all modules are organized into packages.
Full module name consist of the corresponding package name appended with module name. Module name is defined in string ***module hello_world***.

## Debugging
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
