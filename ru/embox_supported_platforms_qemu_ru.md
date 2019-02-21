## Поддержка эмулятора QEMU

Embox поддерживает запуск на QEMU со следующими архитектурами:

* qemu-system-i386
* qemu-system-arm
* qemu-system-mips
* qemu-system-ppc
* qemu-system-microblaze
* qemu-system-sparc

Для каждой архитектуры необходимо установить соответствующий кросс-компилятор

Для каждой из поддерживаемых архитектур необходимо сконфигурировать Embox

```
        $ make confload-<ARCH>/qemu
```
где <ARCH>: x86, arm, mips, ppc, microblaze, sparc

Для запуска можно выполнить скрипт:
```
        $ ./scripts/qemu/auto_qemu
```
данный скрипт разберет содержимое конфигурационных файлов в папке conf/ и запустит qemu c нужными параметрами.


