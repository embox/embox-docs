# Running

## Uploading on qemu
You can run the built image on qemu. The simpliest way is to do `./scripts/qemu/auto_qemu` script:

```
$ sudo ./scripts/qemu/auto_qemu
```
This script makes `tuntab`, it needs to get superuser rights for this purpose. Moreover, the `ethtool` utility used in this script. Installing of `ethtool` for main Debian systems is in the line below:

```
$ sudo apt-get install ethtool
```
If the running has finished successfully, messages will output on qemu screen. After running system the "embox" inviting will appear, so now you can execute commands for implementation. For example, `help` will display list of available commands.

For checking of connection you should ping the `10.0.2.16` interface. If connection is installed, you can to connect to the terminal, using `telnet`.

To exit from qemu, you should type at first `ctrl + a`, and then `X`.


# Отладка

Для работы в режиме отладки можно использовать тот же скрипт, передав ему в качестве параметров флаги -s -S -no-kvm, то есть:

```
$ sudo ./scripts/qemu/auto_qemu -s -S -no-kvm
```
После этого QEMU будет ожидать подключения gdb-клиентом.

Для отладки с помощью консольного отладчика В другом терминале нужно запустить gdb:

```
$ gdb ./build/base/bin/embox
...
(gdb) target extended-remote :1234 
(gdb) continue
```
Cистема начнет загрузку.

В любой момент в терминале gdb можно нажать ctrl + 'c', посмотреть стек текущего потока (backtrace), установить точки останова (break <имя функции>, break <имя файла>:<номер строки>). 
