#### Frame buffer

This sections describes how to use graphical output to display

##### User API
Header file: `#include <drivers/video/fb.h>`

Basic usage:
```
struct fb_info *fb = fb_lookup(0); /* If your config has single display, then lookup fb with id=0 */
```
Screen resolution and other info can be obtained from `fb->var`:
```
struct fb_var_screeninfo {
	uint32_t xres;
	uint32_t yres;
	...
	uint32_t bits_per_pixel;
	...
	uint32_t vmode;
	enum pix_fmt fmt;
};

struct fb_var_screeninfo *var = &fb->var;
```

Frame data is mapped as to address `fb->screen_base`.

```
/* Write white pixel with coords (i, j), assume format is 32-bit RGB */
((uint32_t *) fb->screen_base)[ j * fb->var.xres + i ] = 0xffffffff;
```

###### Converting from one format to another

Currently supported formats are:

* RGB888
* BGR888
* RGBA8888
* BGRA8888
* RGB565
* BGR565

In those names colors appear from least significant byte to most significant. For example, 4-byte color for RGBA8888 is interpreted as follows:

```
  Byte 0       Byte 1        Byte 2       Byte 3        Byte 4
[ 8 bit red ][ 8 bit green][ 8 bit blue][ 8 bit alpha][ 8 bit red for the next pixel ] ...
```

RGB888 and BGR888 are interpreted as 4-byte values, but last byte is ignored.

Following functions can be used to work with pixel formats

```
extern int pix_fmt_has_alpha(enum pix_fmt fmt);
extern int pix_fmt_bpp(enum pix_fmt fmt);
extern int pix_fmt_chan_bits(enum pix_fmt fmt, enum pix_chan chan);
extern int pix_fmt_chan_get_val(enum pix_fmt fmt, enum pix_chan chan,
		void *data);
extern void pix_fmt_chan_set_val(enum pix_fmt fmt, enum pix_chan chan,
		void *data, int val);
extern int pix_fmt_convert(void *src, void *dst, int n,
		enum pix_fmt in, enum pix_fmt out);
```

##### Examples

* Basic example of direct access to frame buffer
 `src/cmds/testing/fb_direct_access/fb_direct_access.c`

* Simple OpenGL scene
 `platform/mesa/cmds/osdemo_fb/osdemo_fb.c`

##### Driver API

There are two essential functions to implement in video driver for a new platform `fb_set_var` and `fb_get_var`.
In the trivial case they can be empty:


```
static int example_set_var(struct fb_info *info,
		struct fb_var_screeninfo const *var) {
	printf("This function should set resolution to %d x %d\n",
		var->xres, var->yres);
	return 0;
}

static int exmaple_get_var(struct fb_info *info,
		struct fb_var_screeninfo *var) {
	printf("This function should fill structure fb_var_screeninfo\n");
	return 0;
}

static struct fb_ops example_fb_ops = {
	.fb_set_var   = example_set_var,
	.fb_get_var   = example_get_var,
};
```

Finally, framebuffer is created by following call:
```
struct fb_info *new_fb = fb_create(&example_ops, screen_base, screen_size /* in bytes */);
```

After that applications can obtain this framebuffer with `fb_lookup()`.

##### Supported controllers
* STM32F7Discovery
* i.MX6 LVDS
* EFM32 LCD display
* PL110 for IntegratorCP
* BOCHS
* Cirrus

#### Flash devices

##### User API
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

##### Driver API

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

Example flash driver implementation: `src/drivers/flash/emulator/emulator.c'

##### Supported controllers
* STM32F3Discovery
* STM32F4Discovery
* Software emulator
