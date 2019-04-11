### Flash-устройства

#### Пользовательский интерфейс
Заголовочный файл: `#include <drivers/flash/flash.h>`

Для работы с флэш-устройствами могут использоваться следующие функции:
```
/* If your configuration has single flash device,
 * probably it's ID is zero */
extern struct flash_dev *flash_by_id(int idx);

extern int flash_read(struct flash_dev *flashdev, unsigned long offset,
		void *buf, size_t len);
extern int flash_write(struct flash_dev *flashdev, unsigned long offset,
		const void *buf, size_t len);
extern int flash_erase(struct flash_dev *flashdev, uint32_t block);
extern int flash_copy(struct flash_dev *flashdev, uint32_t to,
		uint32_t from, size_t len);
```

Также можно использовать flash-устройства через devfs и POSIX/LibC-вызовы (`open()`/`read()`/`write()` и т.п.), стирать блоки можно через `ioctl()`.

```
int fd = open("/dev/stm32_flash", O_RDWR);

flash_ioctl_erase_t arg = {
	.offset = 0xbeef0000,
	.len    = 0x1000
};

ioctl(fd, FLASH_IOCTL_ERASE, &arg);
```

Полный перечень поддерживаемых команду доступен в файле `src/drivers/flash/flash.h`.

#### Интерфейс драйвера

Для реализации flash-драйвера нужно сделать две вещи:
* Реализовать операции в `struct flash_dev_drv`
* При запуске модуля создать устройство `flash_create()`

```
struct flash_dev_drv {
	int	(*flash_init) (void *arg);
	size_t	(*flash_query) (struct flash_dev *dev, void * data, size_t len);
	int	(*flash_erase_block) (struct flash_dev *dev, uint32_t block_base);
	int	(*flash_program) (struct flash_dev *dev, uint32_t base,
				  const void* data, size_t len);
	int	(*flash_read) (struct flash_dev *dev, uint32_t base,
			       void* data, size_t len);
	int	(*flash_copy) (struct flash_dev *dev,
			       uint32_t base_to, uint32_t base_from, size_t len);
};
```

Пример реализации драйвера: `src/drivers/flash/emulator/emulator.c'

#### Supported controllers
* STM32F3Discovery
* STM32F4Discovery
* Программный эмулятор
