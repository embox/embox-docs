# "Hello, World!" example
To write an example of "Hello, World!" command, it's necessary to create the **hello.c** file, written in **C**:
```c
#include <stdio.h>

int main(int argc, char **argv) {
	printf("Hello World!\n");
	return 0;
}
```
And then to add a module description.

## Module addition
All modules and interfaces are described in **my-files**.

**My-files** are files that have the **.my** extension or the **Mybuild** name (without any extension).

**Structurally every my-file contains:**

* package declaring, which owns all entities, declared in the file
* list of imported names from other packages
* determinations of these modules and interfaces.

For instance, to add a new command to command-interpreter(embedded in the kernel), we create new **Hello.my** file with the following content:
```java
package embox.cmd.tutorial

@AutoCmd
@Cmd(name="hello", help="Prints ‘Hello World’ string")
module hello {
	source "hello.c"
}
```
In the example above we described the simple module with the only one **source** attribute – the **hello.c** file that has source code.

This file will be compilled and connected with the kernel in case of the module will be added to the building.

