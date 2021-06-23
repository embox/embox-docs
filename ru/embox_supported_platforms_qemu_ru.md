## Поддержка эмулятора QEMU

Embox поддерживает запуск на QEMU со следующими архитектурами:

* qemu-system-i386
* qemu-system-arm
* qemu-system-aarch64
* qemu-system-mips
* qemu-system-mips64
* qemu-system-ppc
* qemu-system-microblaze
* qemu-system-sparc
* qemu-system-riscv32
* qemu-system-riscv364

Для запуска на требуемой архитектуре необходимо сконфигурировать Embox

```
        $ make confload-<ARCH>/qemu
```
где <ARCH>: x86, arm, aarch64, mips, mips64, ppc, microblaze, sparc, riscv32, riscv64

Собрать образ
```
make
```

Для запуска достаточно выполнить скрипт:
```
        $ ./scripts/qemu/auto_qemu
```
данный скрипт разберет содержимое конфигурационных файлов в папке conf/ и запустит qemu c нужными параметрами. Для каждой архитектуры будет выбрана своя платформа по умолчанию.

