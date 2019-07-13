### Flash devices

#### User API
Header file: `#include <drivers/flash/flash.h>`

Userspace functions to work with flash device:
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

It's also possible to access flash devices via devfs with POSIX or LibC calls
(`open`, `read` work like for regular block device, to erause block you can use
`ioctl`)

```

int fd = open("/dev/stm32_flash", O_RDWR);

flash_getconfig_erase_t arg = {
	.offset = 0xbeef0000,
	.len    = 0x1000
};

ioctl(fd, GET_CONFIG_FLASH_ERASE, &arg);
```

For more details for ioctl calls refer to `src/drivers/flash/flash.h`.

#### Driver API

Two things should be done to implement another flash device driver:

* Implement flash operations for `struct flash_dev_drv`
* Create flash device with `flash_create()`

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

Example flash driver implementation: `src/drivers/flash/emulator/emulator.c`

#### Supported controllers
* STM32F3Discovery
* STM32F4Discovery
* Software emulator
