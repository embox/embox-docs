# Быстрый старт
Лучше начать с запуска Embox на эмуляторе QEMU, который поддерживает разные ЦПУ-архитектуры. 

## Получение кода Embox
Клонируем мастер:
```
    $ git clone https://github.com/embox/embox
```
Либо скачиваем архивом из: [https://github.com/embox/embox/releases](https://github.com/embox/embox/releases)
 
## Запуск в Windows (и MacOS)
### Выполните следующие шаги:
Скачайте актуальную версию PowerShell:

[Алгоритм скачивания PowerShell для Windows](https://learn.microsoft.com/ru-ru/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3)

Зайдите в PowerShell под именем администратора и установите WSL2 (обратите внимание на требования к версии Windows):

[Алгоритм установки WSL2](https://learn.microsoft.com/ru-ru/windows/wsl/install-manual)

Перед тем как перейти к следующему шагу обязательно обновите WSL1 до WSL2 (инструкция по ссылкам выше), в противном случае Embox не запустится под Windows.

### Скачайте Ubuntu из Microsoft Store
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
Клонируйте себе версию проекта (используйте https или ssh):
```
    git clone <https://github.com/embox/embox.git>
    git clone <git@github.com:embox/embox.com>
```
 
Зайдите в папку проекта:
```
    cd embox
```
Выполните 3 команды:
```
    make confload-x86/qemu
    make
    ./scripts/qemu/auto_qemu
```
П. С.: Если у вас возникли трудности с запуском Embox на Windows -- проверьте на корректность введённые команды.
Если команды написаны корректно-- Вы можете воспользоваться рекомендациями из статьи по ссылке:

[Устранение неполадок WSL](https://learn.microsoft.com/ru-ru/windows/wsl/troubleshooting)


## Настройка окружения
Необходимые пакеты: **make**, **gcc** (кросс-компилятор под выбранную архитектуру, см. следующий абзац «Установка кросс-компилятора»).
Дополнительные пакеты (рекомендуется установить сразу): **build-essential**, **gcc-multilib**, **curl**, **libmpc-dev**, **python**.

Пример установки для Ubuntu/Debian:
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
***x86***:
```
     $ sudo apt-get install gcc
```
Обычно эти пакеты уже установлены в Вашей ОС, но на всякий случай стоит это проверить. Вам также понадобится `gcc-multilib`.
Обратите внимание, что требуется установить другие пакеты, если Вы уже настроили окружение на Windows и MacOS самостоятельно.

***ARM***:
```
     $ sudo apt install arm-none-eabi-gcc
```
***Или для Debian***:
```
    $ sudo apt install gcc-arm-none-eabi
```
Вы можете также скачать архив с набором ARM-инструментов(тулчейном) по ссылке: [https://launchpad.net/gcc-arm-embedded](https://launchpad.net/gcc-arm-embedded)
Затем нужно распаковать архив и настроить переменную окружения `PATH`:
```
   $ export PATH=$PATH:<путь к тулчейну>/gcc-arm-none-eabi-<version>/bin
```

### SPARC, Microblaze, MIPS, PowerPC, MSP430:
Для этих архитектур можно воспользоваться нашим проектом по сборке кросс-компилятора: [https://github.com/embox/crosstool](https://github.com/embox/crosstool)

Также можно скачать последнюю версию архива отсюда: [https://github.com/embox/crosstool/releases](https://github.com/embox/crosstool/releases)

Или собрать его, выкачав скрипты из репозитория с помощью команды:
```
    $ ./crosstool.sh ARCH
```
После должен появиться архив с тулчейном — `ARCH-elf-toolchain.tar.bz2`. Затем его нужно распаковать и добавить в переменную окружения `PATH`, как показано выше для ARM.

## Установка эмулятора QEMU
Поддерживаемые архитектуры: `x86`, `ARM`, `MIPS`, `Sparc`, `PPC`, `Microblaze`.

QEMU может быть установлен следующим способом:
```
    $ sudo apt-get install qemu-system-<ARCH> 
```
где `<ARCH>` -- это i386, arm, sparc, mips, ppc или misc (для microblaze).
Примечание: Все пакеты QEMU можно установить единым пакетом:
```
    $ sudo apt-get install qemu-system
```

## Сборка и запуск на QEMU
Загружаем конфигурацию по умолчанию для выбранной архитектуры:
```
   $ make confload-<ARCH>/qemu
```
Где `<ARCH>`: x86, arm, mips, ppc, sparc, microblaze.

Пример под x86:
```
    $ make confload-x86/qemu
```
Собираем Embox:
```
    $ make
```
Чтобы ускорить процесс сборки, Вы можете использовать:
```
    $ make (-jN)
```
Где *-j* -- это опция *make*, а *N* -- это количество параллельных процессов.

Пример:
```
    $ make -j4
```
Теперь Вы можете запустить Embox:
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
Если все unit-тесты прошли успешно, и система загружена, появится консоль, в которой можно выполнять команды. Начать можно с команды ***'help'*** которая выведет список доступных команд для вашей конфигурации.

Для выхода из эмулятора qemu нажмите последовательно: ***ctrl+"A"***, затем ***"x"***.

## Особенности системы сборки Mybuild
***Embox*** - модульная и настраиваемая система. Для этих целей был разработан декларативный язык описания ***Mybuild***.
Он позволяет описывать как отдельные единицы системы (модули), так и всю систему в целом.

***Модуль*** -- это базовое понятие для системы сборки.
Описание модуля содержит: 
    * список файлов, относящихся к данному модулю;
    * параметры, которые можно задать модулю в момент конфигурации;
    * список зависимостей.

***Конфигурация*** -- это детализированное описание системы.
Конфигурация включает в себя:
    * список модулей, необходимых для сборки;
    * параметры модулей;
    * описания правил сборки (компилятор, флаги компилятора, карта памяти устройства, и т. д.). 
    
На основе конфигурации и описания модулей строится граф с параметрами системы, и по нему генерируются различные файлы для сборки: `линкер`, `скрипты`, `makefile-ы`, `заголовочные файлы`. Нет необходимости добавлять все модули, т. к. они будут подтягиваться по зависимостям.

Текущая конфигурация находится в папке ***conf/***. Вы можете настроить её с помощью команды:
```
    $ make confload-<CONF_NAME>
```
Например, чтобы настроить демо конфигурации для ***qemu-system-arm***, необходимо выполнить: 
```
    $ make confload-arm/qemu
```
А чтобы получить список всех доступных конфигураций, используйте:
```
    $ make confload
```
После того, как Вы настроили какую-либо конфигурацию, Вы можете кастомизировать её под свои требования.
    
Чтобы воспользоваться дополнительным приложением, Вы можете вставить в Ваш файл ***conf/mods.conf*** строчку:
```
    include <PACKAGE_NAME><MODULE_NAME>
```
Например, для добавления в конфигурацию команды ***'help'***, наберите:
```
    include embox.cmd.help
```

## Создание и запуск «Hello world»
Приложение в Embox -- это обычный модуль Embox со специальными аттрибутами. Эти аттрибуты определяют Ваш модуль как выполняемую программу.

Исходный код в Embox -- это обычный POSIX-код, написанный на C, поэтому он может компилироваться и под Linux.

### Создание и запуск примера
Чтобы запустить Вашу собственную простейшую программу ***«Hello world»***, Вы можете сделать следующее:

* Создать папку ***hello_world*** в ***src/cmds***:
```
    $ mkdir src/cmds/hello_world
```
* Создать файл с исходным кодом программы ***src/cmds/hello_world/hello_world.c*** со следующим содержанием:
```
        #include <stdio.h>

        int main(int argc, char **argv) {
        	printf("Hello, world!\n");
        }
```
* Создать файл ***src/cmds/hello_world/Mybuild*** с описанием Вашего модуля:
```
        package embox.cmd

        @AutoCmd
        @Cmd(name = "hello_world", help="First Embox application")
        module hello_world {
        	source "hello_world.c"
        }
```
* Добавить программу в файл конфигурации ***conf/mods.conf***:
```
        include embox.cmd.hello_world
```
* Собрать Embox:
``` 
        $ make
```
* Запустить Embox:
```
        $ ./scripts/qemu/auto_qemu
```
* Наберите ***help*** в консоли Embox, чтобы проверить, появилась ли ***hello_world*** в списке команд, и Вы увидите:
```
        root@embox:/#hello_world 
        Hello, world!
        root@embox:/#
```

### Файл описания модуля
Разберем немного подробнее файл описания модуля:
```
        package embox.cmd

        @AutoCmd
        @Cmd(name = "hello_world", help="First Embox application")
        module hello_world {
        	source "hello_world.c"
        }
```
Первая строка содержит в себе пакет с названием **embox.cmd.**. В Embox все модули распределены по пакетам. Полное имя модуля состояит из имени пакета + имени модуля.

Строка source «hello_world.c» содержит названия необходимых для сборки модуля файлов.

В строке ***@Cmd(name = «hello_world», help = «First Embox application»)*** задается атрибут модуля.

В первую очередь модуль будет представлять из себя приложение, а во вторую -- устанавливает имя, с помощью которого это приложение можно вызвать.

И наконец, устанавливается строка, которая будет отображаться при вызове команды ***'help'***.
    
Строка ***@AutoCmd*** показывает, что в приложении есть стандартная функция входа в приложение ***main()***, которая будет заменена на другой символ в процессе сборки.

## Отладка
Для отладки можно использовать тот же «auto_qemu» скрипт, добавив флаги `-s`, `-S`, `-no-kvm`:
```
    $ sudo ./scripts/qemu/auto_qemu -s -S -no-kvm
```
После запуска qemu ждёт соединения с gdb-клиентом. Запустим gdb в другом терминале:
```
    $ gdb ./build/base/bin/embox
    ...
    (gdb) target extended-remote :1234
    (gdb) continue
```
Система начала загружаться.

В любой момент в gdb терминале Вы можете нажать `ctrl + C` и посмотреть стек текущего потока (`backtrace`) или установить брейкпоинты (`break <function name>`, `break <file name>:<line number>`).

## Подключение внешнего репозитория для модулей и темплейтов
Embox допускает подключение внешнего репозитория для модулей и темлейтов. Для того, чтобы это сделать, достаточно указать корневую папку репозитория:
```
        make ext_conf EXT_PROJECT_PATH=<your projects path>
```
Для того, чтобы темплейты были видны через вызовы `make confload` и `make confload-`, подключеный репозиторий должен иметь структуру папки *project*, а именно *<root_folder>/<project_name>/templates*. Модули могут располагаться в произвольных папках, поиск осуществляется по файлам Mybuild и *.my
