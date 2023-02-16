# Быстрый старт
Ознакомление с Embox лучше начать с запуска на эмуляторе ***qemu*** поддерживающего различные процессорные архитектуры.

## Получение кода Embox
Клонируем мастер:
```
    $ git clone https://github.com/embox/embox
```
Либо скачиваем архивом из [https://github.com/embox/embox/releases](https://github.com/embox/embox/releases)
 
## Запуск в Windows  и MacOS

### Выполните следующие шаги:

Скачайте актуальную версию PowerShell

[Алгоритм скачивания PowerShell для Windows](https://learn.microsoft.com/ru-ru/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3)


Зайдите в PowerShell под именем администратора и установите WSL2 (обратите внимание на требования к версии Windows)

   [Алгоритм установки WSL2](https://learn.microsoft.com/ru-ru/windows/wsl/install-manual)


```
Перед тем как перейти к следующему шагу обязательно обновите WSL1 до WSL2
(инструкция по ссылкам выше), в противном случае Embox не запустится под Windows
```

Скачайте Ubuntu из Microsoft Store


Убедитесь, что у Вас стоит WSL версии 2, для этого введите в PowerShell команду:
```
    wsl -l -v
```
Выполните в командной строке Ubuntu следующие команды для установки необходимых для запуска программ:
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

Клонируйте себе версию проекта(используйте https или ssh)

   git clone <https://github.com/embox/embox.git>
   git clone <git@github.com:embox/embox.com>

 
Зайдите в папку проекта
```
    cd embox
```
Выполните 3 команды
```
    make confload-x86/qemu
    make
    ./scripts/qemu/auto_qemu
```
П. С.: Если у вас возникли трудности с запуском Embox на Windows -- проверьте на корректность введённые команды.
Если команды написаны корректно-- Вы можете воспользоваться рекомендациями из статьи по ссылке:

   [Устранение неполадок WSL](https://learn.microsoft.com/ru-ru/windows/wsl/troubleshooting)
  


## Настройка окружения
Необходимые пакеты: make, gcc (кросс-компилятор под выбранную архитектуру,  см. “Установка кросс-компилятора”).
Дополнительные пакеты (рекомендуется установить сразу): build-essential gcc-multilib curl libmpc-dev python
Пример установки для Debian:
```
    $ sudo apt-get install make gcc \
        build-essential gcc-multilib \
        curl libmpc-dev python
```
Пример установка для Arch:
```
    $ sudo pacman -S make gcc-multilib cpio qemu
```

## Установка кросс-компилятора 
### x86:
```
     $ sudo apt-get install gcc
```
Обычно уже установленный пакет. Вам потребуется другой компилятор, если Вы настраиваете окружение самостоятельно для Windows или MacOS.

### ARM:
```
     $ sudo apt install arm-none-eabi-gcc
```
Или для Debian
```
    $ sudo apt install gcc-arm-none-eabi
```
Либо скачать архив с тулчейном с сайта [https://launchpad.net/gcc-arm-embedded](https://launchpad.net/gcc-arm-embedded). Распаковать архив и сделать export тулчейна:
```
   $ export PATH=$PATH:<путь к тулчейну>/gcc-arm-none-eabi-<version>/bin
```

### SPARC, Microblaze, MIPS, PowerPC, MSP430:
Для этих архитектур можно воспользоваться нашим проектом по сборке crosstool [https://github.com/embox/crosstool](https://github.com/embox/crosstool).

Можно скачать последнюю версию уже собранного архива в требуемым кросс-компилятором отсюда [https://github.com/embox/crosstool/releases](https://github.com/embox/crosstool/releases).

Или собрать его выкачав скрипты из репозитория с помощью команды 
```
    $ ./crosstool.sh ARCH
```
После этого должен появиться архив с тулчейном — ARCH-elf-toolchain.tar.bz2. Далее, его нужно распаковать и добавить в переменную окружения PATH как показано выше для ARM.

## Установка эмулятора QEMU
Поддерживаемые архитектуры: x86, ARM, MIPS, Sparc, PPC, Microblaze.

Необходимые пакеты: qemu (под выбранную архитектуру)
```
    $ sudo apt-get install qemu-system-<ARCH> 
```
где <ARCH> это i386, arm, sparc, mips, ppc или misc (для microblaze)
Примечание: Все пакеты qemu можно установить единым пакетом — 
```
    $ sudo apt-get install qemu-system
```

## Сборка и запуск на QEMU
Загружаем конфигурацию по умолчанию для выбранной архитектуры:
```
   $ make confload-<ARCH>/qemu
```
, где <ARCH>: x86, arm, mips, ppc, sparc, microblaze.
Пример под x86:
```
    $ make confload-x86/qemu
```
Собираем Embox:
```
    $ make
```
или запускаем параллельную сборку:
```
    $ make (-jN)
```
Пример:
```
    $ make -j4
```
Запускаем:
```
    $ ./scripts/qemu/auto_qemu
```

Пример вывода в консоль:
```
Embox kernel start
    unit: initializing embox.kernel.task.task_resource: done
    unit: initializing embox.mem.vmem_alloc: done
    ...
```
Если все unit тесты прошли успешно и система загружена, появиться консоль в которой можно выполнять команды. Начать можно с команды ***'help'*** которая выведет список доступных команд для вашей конфигурации.
Для выхода из эмулятора qemu нажмите последовательно ***ctrl+’A’*** затем ***‘x’***.

## Особенности системы сборки Mybuild
***Embox*** - модульная и конфигурируемая система. Для этих целей был разработан декларативный язык описания ***Mybuild***. Он позволяет описывать как отдельные единицы системы (модули) так и всю систему в целом.

***Модуль*** является базовым понятием для системы сборки. Он содержит: список файлов относящихся к данному модулю, параметры которые можно задать модулю в момент конфигурации и список зависимостей.

***Конфигурация*** является детализированным описанием желаемой системы. Включает в себя: список модулей необходимых для сборки, параметры модулей и описания правил сборки (компилятор, флаги компилятора, карта памяти устройства, и так далее). На основе конфигурации и описания модулей строится граф с параметрами системы и по нему генерируются различные файлы для сборки: линкер скрипты, makefile-ы, заголовочные файлы. В конфигурации не обязательно указывать все необходимые модули, они подтягиваются по зависимостям из описания модулей.

Текущая конфигурация располагается в папке ***conf/***. Может быть выбрана с помощью команды
```
    $ make confload-<CONF_NAME>
```
Например, для задания демонстрационной конфигурации для запуска на ***qemu-system-arm*** необходимо выполнить 
```
    $ make confload-arm/qemu
```
Для просмотра готовых конфигураций можно выполнить
```
    $ make confload
```
После задания текущей конфигурации можно изменять файлы под свои требования. Например, чтобы добавить какое нибудь приложение которого нет в текущей конфигурации достаточно добавить в файл ***conf/mods.conf*** строку
```
    include <PACKAGE_NAME><MODULE_NAME>
```
Пример, для добавления в конфигурацию команды ***'help'*** нужно добавить строчку
```
    include embox.cmd.help
```

## Создание и запуск "hello world"
Приложение в Embox представляет собой модуль в описании которого содержаться атрибуты указывающие, что это приложение можно запускать из командной строки. Исходный код представляет собой обычное приложение которое можно скомпилировать с том числе и в Linux окружении.

### Создание и запуск примера
Разберем простейшее приложение ***"hello world"***.

* Создадим папку ***hello_world*** в ***src/cmds***:
```shell
    $ mkdir src/cmds/hello_world
```
* Создадим файл с исходным кодом приложения ***src/cmds/hello_world/hello_world.c*** со следующим содержанием:

``` c
        #include <stdio.h>

        int main(int argc, char **argv) {
        	printf("Hello, world!\n");
        }
```

* Создадим файл описания модуля ***src/cmds/hello_world/Mybuild*** следующего содержания:

```java 
        package embox.cmd

        @AutoCmd
        @Cmd(name = "hello_world", help="First Embox application")
        module hello_world {
        	source "hello_world.c"
        }
```
* Добавим в файл конфигурации системы conf/mods.conf строчку с подключением нового модуля:

```
        include embox.cmd.hello_world
```
* Компилируем:

``` shell
        $ make
```
* Запускаем:

``` shell
        $ ./scripts/qemu/auto_qemu
```
В появившейся консоли убедимся, что если набрать команду ***'help'*** то в списке будет новая команда. Выполним команду набрав ее в консоли ***hello_world***
Должно появиться наше сообщение выведенное с помощью функции ***printf()*** :

```shell
        root@embox:/#hello_world 
        Hello, world!
        root@embox:/#
```

### Файл описания модуля
Разберем немного подробнее файл описания модуля.

```java
        package embox.cmd

        @AutoCmd
        @Cmd(name = "hello_world", help="First Embox application")
        module hello_world {
        	source "hello_world.c"
        }
```
В первой строке идет указание имени пакета ***package embox.cmd***. В Embox все модули распределены по пакетам, для удобства именования. Полное имя модуля будет состоять из имени пакета и имени модуля. Имя модуля в нашем случае находиться в строке ***module hello_world***.

Строка ***source "hello_world.c"*** указывает файлы с исходным кодом необходимые для корректной сборки модуля.

В строке ***@Cmd(name = "hello_world", help="First Embox application")*** задается атрибут для модуля. Во первых модуль будет представлять из себя приложение, во вторых задает имя с помощью которого это приложение можно вызвать. И наконец, задается строка, которая будет отображаться для этого приложения при вызове команды ***'help'***. Строка @AutoCmd указывает, что в приложении есть стандартная функция входа в приложение ***main()***, которая будет заменена на другой символ в процессе сборки.

## Отладка
 Для отладки можно использовать тот же'auto_qemu' скрипт только добавив флаги *-s -S -no-kvm*:
```
$ sudo ./scripts/qemu/auto_qemu -s -S -no-kvm
```
После запуска в режиме отлажки qemu будет ждать подключения к внутреннему gdb серверу. Запустите gdb другой консоли:
```
$ gdb ./build/base/bin/embox
...
(gdb) target extended-remote :1234
(gdb) continue
```
После этого Embox стартует как и в режиме без отладки.

В консоли с gdb клиентом вы можете прервать выполнение <kbd>ctrl + C</kbd>, и выполнить команды gdb. Наприме посмотреть стек трейс с помощью команды (`backtrace`) или установить точку останова (`break <function name>`, `break <file name>:<line number>`).

## Подключение внешнего репозитория для модулей и темплейтов
Embox допускает подключение внешнего репозитория для модулей и темлейтов. Для того чтобы это сделать достаточно указать корневую папку репозитория
```
        make ext_conf EXT_PROJECT_PATH=<your projects path>
```
Для того чтобы темплейты были видны через вызовы `make confload` и `make confload-` подключеный репозиторий должен иметь структуру папки project, а именно <root_folder>/<project_name>/templates. Модули могут располагаться в произвольных папках, поиск осуществляется по файлам Mybuild и *.my

