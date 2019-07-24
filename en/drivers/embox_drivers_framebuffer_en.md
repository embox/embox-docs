### Frame buffer

This sections describes how to use graphical output to display

#### User API
Header file: `#include <drivers/video/fb.h>`

Basic usage:

```c
struct fb_info *fb = fb_lookup(0); /* If your config has single display, then lookup fb with id=0 */
```
Screen resolution and other info can be obtained from `fb->var`:

```c
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

```c
/* Write white pixel with coords (i, j), assume format is 32-bit RGB */
((uint32_t *) fb->screen_base)[ j * fb->var.xres + i ] = 0xffffffff;
```

##### Converting from one format to another

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

```c
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

#### Examples

* Basic example of direct access to frame buffer
 `src/cmds/testing/fb_direct_access/fb_direct_access.c`

* Simple OpenGL scene
 `platform/mesa/cmds/osdemo_fb/osdemo_fb.c`

#### Driver API

There are two essential functions to implement in video driver for a new platform `fb_set_var` and `fb_get_var`.
In the trivial case they can be empty:


```c
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

```c
struct fb_info *new_fb = fb_create(&example_ops, screen_base, screen_size /* in bytes */);
```

After that applications can obtain this framebuffer with `fb_lookup()`.

#### Supported controllers
* STM32F7Discovery
* i.MX6 LVDS
* EFM32 LCD display
* PL110 for IntegratorCP
* BOCHS
* Cirrus

