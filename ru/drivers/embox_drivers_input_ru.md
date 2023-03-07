###  Устройства ввода (input devices)

Интерфейс устройств ввода обеспечивает взаимодействие с интерактивным устройством через генерацию и выборку событий.

#### Интерфейс пользователя

Заголовочный файл:

```C
 #include <drivers/input/input_dev.h>
```

Есть два способа получения событий от некоторого устройства с именем "somedev":
 1) с помощью файлового интерфейса;
 2) с помощью специального API input_dev.
 
##### Файловый интерфейс

```C
    int fd = open("/dev/somedev", O_RDONLY);
    // ..and check if fd==-1 means open failed
    ...
    struct input_event ev;
    while (1) {
    	if (read(fd, &ev, sizeof ev) <= 0) {
    		continue; // no events just now
    	}
    	... // Do something with ev
    }
```
  
  При этом программа заперта в цикле обработки этих сообщений;
  

##### API input_dev

```C
static int indev_cb(struct input_dev *indev) {
	struct input_event ev;

	while (0 == input_dev_event(indev, &ev)) {
	... //  Do something with ev
	}

	return 0;
}

int main(int argc, char **argv) {
	...
	struct input_dev *indev = input_dev_lookup("somedev");
	// ..and check if indev==NULL means no such input device
	int res = input_dev_open(indev, indev_cb);
	// ..and check if res!=0 means open failed
	...
	input_dev_close(indev);
}
```

  При этом после вызова `input_dev_open` выполнение программы продолжается, а все сообщения от устройства обрабатываются в `indev_cb`.

#### Реализация

Ниже приведен шаблон кода драйвера "somedev.c" для некоторого устройства "somedev". Предполагается, что устройство - единственное в системе. Прием данных с устройства и упаковка их в последовательность событий происходит в обработчике прерывания `somedev_handler`. Регистрация в системе и предварительная настройка устройства - в `somedev_init`. Включение и выключение устройства (подключение/отключение обработчика прерывания) - в `somedev_start` и `somedev_stop`.

```C
// Интерфейс отладки (и обработки исключений)
#include <util/log.h>  // log_error()/log_debug() interface
//#include <errno.h>
//#include <assert.h>

// Интерфейс системы
#include <drivers/input/input_dev.h>

// Инициализация и регистрация устройства на этапе загрузки Embox производится в somedev_init()
#include <embox/unit.h>
EMBOX_UNIT_INIT(somedev_init);

// Извлечение параметров устройства из файлов конфигурации
#include <framework/mod/options.h>
#define SOMEDEV_PARAM OPTION_GET(NUMBER, param1)

// Обработчик прерывания устройства
static void somedev_handler(<...>, void *param) { // <...> - interrupt specific parameters
	struct input_dev *dev = (struct input_dev *)param;
	struct input_event ev;

	ev.type = SOMEDEV_EV_TYPE; // See input_dev.h and input_codes.h
	ev.value = SOMEDEV_EV_VALUE;
	input_dev_report_event(dev, &ev);

	log_debug("SOMEDEV EVENT OCCURE");
}

// Вызывается из open() или input_dev_open()
static int somedev_start(struct input_dev *dev) {
	// Turn on somedev handler
	return 0;
}

// Вызывается из close() или input_dev_close()
static int somedev_stop(struct input_dev *dev) {
	// Turn off somedev handler
	return 0;
}

// Структуры данных для регистрации (единственного!) устройства в системе
static const struct input_dev_ops somedev_ops = {
	.start=somedev_start,
	.stop=somedev_stop
};

static struct input_dev somedev = {
	.indev = {
		.ops = &somedev_ops,
		.name = "somedev",
		.type = INPUT_DEV_SOMEDEV_TYPE
	}
};

// Инициализация и регистрация устройства на этапе загрузки Embox
static int somedev_init(void) {
	int ret = 0;

	// Driver registration
	ret = input_dev_register(&somedev.indev);
	if (ret != 0) {
		log_error("somedev registation failed");
		goto err_out;
	}

	somedev.indev.data = (void *) &<...>;
	// <...> - device specific parameters, can be used in all functions above

	// Somedev initialization
	// .....

err_out:
	return ret;
}   
```

Make-файл Mybuild:

```
package embox.driver.input

module somedev {
	option number param1 = 0

	source "somedev.c"

	depends embox.driver.input.core
}
```

Файл конфигурации mods.conf:

```
	...
	include embox.driver.input.somedev
	...
```
                                                                                                                     
