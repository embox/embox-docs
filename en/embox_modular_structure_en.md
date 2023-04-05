# Modular structure of Embox

Important features of Embox are: **modularity** and **configurability**.

A **modularity** is splitting project into small logical parts that is modules.

And **configurability** is ability to determinate the characteristics of the end system,
based on list of modules and their parameters.

For this purpose we use "Mybuild" assembly system with a dictionary specification language,
which allows to describe the modules and system as a whole.

At the same time, programming logic of modules is located separately from a description
and it's developed on general-purpose programming language.

## The files of module description
### The packages of modules
Modules are organized into hierarhical groups (namespace).
This structure allows to avoid mess in names of modules and makes them short.

As usual, package name coincides with the path in the file system.
It relieves search for module files in source code tree.

The example of package naming:
```java
   package embox.arch
```
### Interfaces and abstract modules
Interfaces for modules are direct analogues of abstract classes and interfaces in OOP.

**Module description language** supports **interface** that allows to to introduce the next points:

* the **interface** concept (modules without implementation)
* **abstract modules** (modules with partial implementation)

This method allows you to choose from the list of modules (that implement the same interface, but have different algorithms) the needed one.

To mark a module as inherited, you need to use the `abstract` keyword.
The example of module declaration:
```java
   package embox.arch
   //...
   abstract module interrupt {}
   //...
```
To point at inheritance, we use `extends` keyword.
The instance of inheritance from the abstract module:
```java
   module interrupt_stub extends embox.arch.interrupt {
   //...
   }
```
### Attributes of modules
Description of every module consists of several possible attributes:

* **files of source code**
* **options**
* **dependencies**

#### Files of source code
A module can point at list of file, which you need to compile and to add in a final image.

Except **"ordinary" files** in C and assembler, it's possible to include **header files** and **additional linker scripts**.

**Types of files differ according to file extension: ".c/.S", ".h", ".lds.S".**

**".c/.S"** is a **source code**, written in C or assembler. In the assembly process it's compelled and included in final image of system.
During the compilation it's possible to get values of options of module that connected with files of source code.

**".h"** is a **header file** containing the definitions, needed for implementation of interface.
During the building of module the special header file is generated. It has all listed .h-files of this module.

It allows you to use different implementations of some interface without changing the source code of the modules that use it.
Such way of abstraction is necessary, because different implementations can define one or the other structure in different ways
while this structure can be used by other modules without knowledge about details of implementation.

**".lds.S"** are **linker scripts** that allow you to affect on loading the modules in final image. The typical using is an addition of new sections.

The example of adding the **".h-file"** to the module:
```java
   module interrupt_stub extends embox.arch.interrupt {
      source "interrupt_stub.h"
   }
```
The instance of adding the **".lds.S-file"** and **".c-file"** to the module:
```java
   module static_heap extends heap_place {
      //...
         source "heap.lds.S"
         source "static_heap.c"
      //...

   }
```

#### Options
**The characteristics of options:**
* allow you to define numerical, boolean and string parameters at the configuration stage
* can have default value, if the value doesn't exist -- ad it to your configuration

Options allow you to define **numerical**, **boolean** and **string parameters** at the configuration stage.

These **parameters can affect how the module is assembled, initialized** and **how it works**.

To define a type of some options, it's needed to write it after the `option` keyword.

To get a value of some option during the compilation of source code, it's used the next **special macros**:
* **OPTION_STRING_GET** is for string options
* **OPTION_NUMBER_GET** is for numerical options
* **OPTION_BOOLEAN_GET** is for boolean options
The argument of macro is option name defined in **my-file**.

#### Dependencies
**Dependencies** are the way to show to the assembly system that the correct module working is impossible without other ones.

The **list of dependencies** can include some interfaces.
It means that only one module implemented required interface can be included in a building.

Use the **"depends"** attribute to define dependencies between modules.
You can count modules and interfaces in value of this attribute.

Assembly system guarantees that the dependencies of specific module will be added when this module is included in the system.

In some cases you just need **to add a module** what you need **without changing the loading order**.
This method is used for such global modules as, **for example**: **"multiprocessing support"**, **"logging"**, **"debug statement" (assert)**.

Due to the fact that these **modules don't have a status** in the usual sence (such as **"loaded"** or **"unloaded"**),
it's required to add the ***@NoRuntime*** annotation to the **"depends"** attribute.

In this case, the dependencies will be used during the building , but won't determine module loading order.

### Annotations
**The characteristics of annotations:**
* are used for changing the semantics of description elements
* allow to extend description language without changing the grammar
* make description language more flexible

The instance of implementation the abstract module with help of the annotation:
```java
   @DefaultImpl(embox.arch.generic.interrupt_stub)
   abstract module interrupt {}
```

## Configuration description
**Module description** is used to create a target image.

During the configuration the assembly system allows to merge modules of system (e. g. kernel modules, drivers, tests, applications)
and to install parameters for these, and also to define additional parameters to create an image for different hardware platforms.

### The structure of configuration
Image configuration is running through file editing in the **"conf/"** directory.
It contains the following:
* **"lds.conf"** -- contains the definition of memory card, which is used by specific hardware platforms
* **"mods.conf"** -- contains names and options of modules, which will be included in OS image.
Also you can set every modules in this file to new values
* **"rootfs"** -- contains files, which will be included into the file system

### Configuration process
To use some module in OS image means to add it into some OS configuration.

#### Basic configuration
A preparation any configuration to building is a long process. A basic configuration is used to save your time.

OS has several configuration that intended to be used as basic.
Several configurations with different properties have been prepared for each platform.

For example, to get a basic configuration to support x86 platform, use the next command:
```
   make confload-x86/qemu
```
This command loads basic "qemu" configuration for x86 platform in the **"conf/"** directory.

The list of basic configurations you can see and choose the needed one, type:
```
   make confload
```

#### Inclusion of module into configurations
The list of modules (that you can include in your configuration) locates in the "conf/mods.conf".
This file has the next structure:
```
   package genconfig

   configuration conf {
      [module_list]
   }
```
Where **[module_list]** defines the position of set of strings, each of the last ones is responsible for inclusion.

Add a new line to the module list:
```
   include pkg.new_package.empty
```
To get the following:
```
   package genconfig

   configuration conf {
      [module_list]
      include pkg.new_package.empty
  }
```
Then the "empty" module from "pkg.new_package" will be included in the building.

To check the consistency of received building and to create OS image, type:
```
   make
```
If everything was completed successful, you'll see the "Build complete" message on your screen.

To be confident that new module appeared in OS, do the following:
```
   lsmod -n empty
```
We typed the "lsmod" command with the "-n" and "empty" parameters in the line above.
This command displays the list of module list, which have in their names "empty" substring.

The result of "lsmod" is below:
```
   * pkg.new_package.empty
```
This output tells us that the "pkg.new_package.empty" is in the system, and the `*` symbol -- that at this moment the module is loaded and it works.
