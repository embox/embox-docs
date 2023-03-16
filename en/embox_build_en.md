# Building

## Project configuration
A configuration is the list of modules and their parameters on the one side, and set of requirements to system functionality on the other. Check the "Modular structure of Embox" section for more details. The current configuration is in the files of "conf/" directory.

## Choice of configuration
To set the configuration with desired properties, it's necessary to describe these properties in the "conf/" directory. But if the similar configuration is already exists, it'll be more easy for you to use the existing description as a base for making your own configuration.

You can see the existing configuration, using the next command:
```
    $ make confload
```
After it's possible to load the chosen configuration the next way:
```
    $ make confload-<template>
```
To pay attention: after running the "make confload-", your "conf/" directory will have files of chosen configuration. And files, that were in this directory before will be deleted.

In the next example we choose the existing "platform/quake3/qemu" configuration from the list:
```
    $ make confload
    List of available templates:
      ...
      platform/quake3/qemu
      ...
    Use 'make confload-<template>' to load one.

    $ make confload-platform/quake3/qemu
```

## Building made of existing configuration
To build the image, it's necessary to set the chosen configuration as a current one how it was shown in the previous example. And then to run: 
```
    $ make
```
If everything is correct, you'll see the "Build complete" message. Also the ELF-file of the image will appear in the "build/base/bin/embox" path.

For instance:
```
    text	   data	    bss	    dec	    hex	filename
    1259425	 248540	170593504	172101469	a420f5d	build/base/bin/embox
    Build complete
```

## Changing system characteristics
After selection of configuration you can change it, using "conf/" file. We remind you: if to run "make confload-" or make cleaning, that connected with current configuration (e. g. "make distclean"), current changes will be lost.

### Changing system functionality
#### Modification of the modules list
"Mods.conf" file contains a description of system functionality, so you should use this file if you want to change functionality. For example, to add a new command to the list, it's necessary to insert to "mods.conf" file the next line:
```
    include <PACKAGE_NAME>.<MODULE_NAME>
```
For instance:
```
    include embox.cmds.help
```
The same way also works in case of standard modules.

#### Module parameters
To set size of thread stack, you need to change (or to add) the *thread_stack_size* parameter in the *embox.kernel.thread.core* module:
```
    include embox.kernel.thread.core(thread_stack_size=0x4000)
```

#### Load order
You can manage the order, in which the modules of system load in configuration. Use the «@Runlevel(level)» (e. g. *@Runlevel(2)*) attribute for this purpose, but usually it's not required, because modules are loading according to dependencies (if some module *B* depends on some module *A*, then *A* will be loaded before *B*).


#### Changing of interface implementation
To change interface implementation (that is the same as abstraction module; see "The modular structure of Embox" section for more details), you need just to add a module of this interface to your configuration.

For example, the abstract module *heap_api*:
```
    @DefaultImpl(heap_bm)
    abstract module heap_api {
    	...
    }
```
To add the *heap_simple* module,
```
    module heap_simple extends heap_api {module heap_simple extends heap_api {
    ...
    }
```
it's necessary to delete *heap_bm* module (if you have it), that is the same as the next line:
```
    include embox.mem.heap_bm
```
and then to do:
```
    include embox.mem.heap_simple
```

### Changing flags of compilation (debugging, optimization)
You can manage some flags of compilation. The "conf/build.conf" has them. For example, flag of optimization (that often requires to make changes):
```
    CFLAGS += -O0
```
To build the Embox with optimization 2, you should the line above to the next one:
```
    CFLAGS += -O2
```
Also another important flag is the *-g* linker flag, that is the same as adding debugging information in system image:
```
    LDFLAGS += -N -g
```
You can delete this flag for size reduction, but in this case the debugging will be unavailable.

## Cleaning the project
Embox building has several stages. The main of them are:

* Project configuration
* Creating modules dependency graph and using it for generation of artifacts for building
* Building itself (compilation, linking)

You can reset (clean) the project to different stages of building. The are the next three make-goals for this purpose:

* make distclean
* make cacheclean
* make clean

The *clean*-goal just deletes "build" directory with objects and binary files. It's enough for most cases.

The *cacheclean*-goal also deletes "build" directory as the previous goal, but in addition *cacheclean* also deletes "mk/.cache" directory,that contains artifacts from Mybuild-files.

The *distclean*-goal resets  the project to its original state. That is deleting the working configuration, cleaning all generated and compiled files.

## Useful commands

### Information about commands of building
You can get more information about feachures of command line, using: 
```
    $ make help
```
There are different subsections of the *help* goal, for example, *help-mod*:
```
    $ make help-mod
```
To get more information about modules management you can the next way:
```
Usage: make mod-<INFO>

  Print <INFO> info about modules:
  list: list all modules included in build
  brief-<module_name>: show brief informataion about module: dependencies, options,
	source files
  include-reason-<module_name>: show dependence subtree desribing why <module_name>
    was included in build
```

### Getting disassembler of current image
You can get the file with disassembler, using the command below:
```
    $ make disasm
```

### Getting the graph of modules
The command below will allow you to get graph of modules in png-format:
```
    $ make dot
```
После выполнения команды *$ make dot* появится файл *build/doc/embox.png*.After running *make dot* command the *build/doc/embox.png* will appear.

You'll need to install the *graphviz* package:
```
   $ sudo apt install graphviz
```

### Getting documentation from doxygen-comments
To generate docs based on doxygen-comments, you can do:
```
    $ make docsgen
```
After running the command above the *build/docs/html* directory, that has generated html-documentation, will appear.

Also you'll need to install the *doxygen* package:
```
   $ sudo apt install doxygen
```

### Управление модулями
Для получения списка всех модулей, которые включены в текущую конфигурацию, нужно выполнить команду:
```
   $ make mod-list
```

Можно получить более подробную информацию по каждому модулю. Например, информацию о модуле *embox.net.route* можно получить с помощью команды:
```
    $ make mod-brief-embox.net.route
```
В результате Вы получите следующий вывод:
```
    --- embox.net.route ---
    Inclusion reason: as dependence
    Depends:
   	embox.net.core
    	embox.mem.pool_ndebug
    	embox.util.DListDebug
    Dependents:
    	embox.cmd.net.ping
     	embox.cmd.net.route
     	embox.net.af_inet
     	embox.net.ipv4
     	embox.net.tcp_sock
    OptInsts:
    	route_table_size : 8
    Sources:
     src/net/l3/route.c
```
Из полученного выше результата можно узнать: список файлов, включённых в модуль; опции с уже установленными значениями; причину, по которой включен модуль (напрямую из конфига или подтянулся по зависимостям) и зависимости самого модуля.

Иногда нужно понять, почему подключается тот или иной модуль. Для этого можно воспользоваться командой:
```
    make include-reason-<module_name>
```
Продемонстрируем работу этой команды на примере того же модуля *embox.net.route*:
```
    $ make mod-include-reason-embox.net.route
    embox.net.route: as dependence:
    	embox.cmd.net.ping: explicit
    	embox.cmd.net.route: explicit
    	embox.net.af_inet: explicit
    	embox.net.ipv4: explicit
    	embox.net.tcp_sock: explicit
    #
```
