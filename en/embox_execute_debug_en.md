# Running

## Uploading on qemu
You can run the built image on qemu. The simpliest way is to do `./scripts/qemu/auto_qemu` script:

```c
$ sudo ./scripts/qemu/auto_qemu
```
This script makes `tuntab`, it needs to get superuser rights for this purpose. Moreover, the `ethtool` utility used in this script. Installing of `ethtool` for main Debian systems is in the line below:

```c
$ sudo apt-get install ethtool
```
If the running has finished successfully, messages will output on qemu screen. After running system the "embox" inviting will appear, so now you can execute commands for implementation. For example, `help` will display list of available commands.

For checking of connection you should ping the `10.0.2.16` interface. If connection is installed, you can to connect to the terminal, using `telnet`.

To exit from qemu, you should type at first `ctrl + a`, and then `X`.


# Debugging

You can use the same script for working in debugging mod. For this purpose just send `-s`, `-S`, `-no-kvm` flags as parameters to this script as follows:

```c
$ sudo ./scripts/qemu/auto_qemu -s -S -no-kvm
```
After qemu will wait connection of gdb-client.

For debugging with help of console bebugger it's necessary to run gdb in other terminal:

```c
$ gdb ./build/base/bin/embox
...
(gdb) target extended-remote :1234 
(gdb) continue
```
The system'll start loading.

In any moment you can type `ctrl + c` in gdb-terminal and see current thread stack (backtrace), then to install breakpoints (break <name of function>, break <name of file>:<line number>).
