## QEMU emulator support

Embox supports following QEMUs:

* qemu-system-i386
* qemu-system-arm
* qemu-system-mips
* qemu-system-ppc
* qemu-system-microblaze
* qemu-system-sparc

For each of supported CPU architectures you have to configure Embox by follow shell command:

```
        $ make confload-<ARCH>/qemu
```
where <ARCH>: x86, arm, mips, ppc, microblaze, sparc

For running you should execute `auto_qemu` script:
```
        $ ./scripts/qemu/auto_qemu
```
The script parses config files from `conf/` folder and starts `qemu` with corresponded arguments.


