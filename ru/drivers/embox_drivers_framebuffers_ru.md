### Видео-вывод (framebuffer)

#### Интерфейс пользователя
Заголовочный файл: `#include <drivers/video/fb.h>`

Использование:
```
struct fb_info *fb = fb_lookup(0); /* Если в конфигурации используется единственный дисплей, его id будет 0 */
```
Разрешение экрана и прочую информацию можно получить в  `fb->var`:
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

Содержимое экрана доступно по адресу `fb->screen_base`.

```
/* Запись белого цвета в пиксель (i, j), формат 32-bit RGB */
((uint32_t *) fb->screen_base)[ j * fb->var.xres + i ] = 0xffffffff;
```

##### Конвертация форматов

Поддерживаются следующие форматы:

* RGB888
* BGR888
* RGBA8888
* BGRA8888
* RGB565
* BGR565

Порядок цветов (R -- красный, G -- зелёный, B -- синий, A -- прозрачность) говорит об их расположении внутри соответстующего пикселя, начиная от младших битов к старшим.
Например, RGBA8888 интерпретируется следующим:

```
  Byte 0       Byte 1        Byte 2       Byte 3        Byte 4
[ 8 bit red ][ 8 bit green][ 8 bit blue][ 8 bit alpha][ 8 bit red for the next pixel ] ...
```

RGB888 и BGR888 интерпретируются как 32-битные цвета, но старшие 8 бит не учитываются.

Следующие функции используются для работы с разными форматами пикселей.

```
extern int pix_fmt_has_alpha(enum pix_fmt fmt); /* Есть ли прозрачность */
extern int pix_fmt_bpp(enum pix_fmt fmt);       /* Глубина в биах */
extern int pix_fmt_chan_bits(enum pix_fmt fmt, enum pix_chan chan);
                                                /* Глубина канала в битах */
extern int pix_fmt_chan_get_val(enum pix_fmt fmt, enum pix_chan chan,
		void *data);                    /* Извлечь канал из пикселя */
extern void pix_fmt_chan_set_val(enum pix_fmt fmt, enum pix_chan chan,
		void *data, int val);           /* Установить значение одного канала */
extern int pix_fmt_convert(void *src, void *dst, int n,
		enum pix_fmt in, enum pix_fmt out);
		                                /* Конвертировать изображение */
```

#### Примеры использования

* Пример доступа к фрейм-буфферу
 `src/cmds/testing/fb_direct_access/fb_direct_access.c`

* Пример простой OpenGL-сцены
 `platform/mesa/cmds/osdemo_fb/osdemo_fb.c`

#### Интерфейс для драйвера

Для реализации драйвера нужно предоставить две функции: `fb_set_var` и `fb_get_var`.
В самом простом случае они могут быть заглушками.

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

При запуске модуля нужно создать фрейм-буффер:
```
struct fb_info *new_fb = fb_create(&example_ops, screen_base, screen_size /* in bytes */);
```

После этого приложения могут использовать этот буффер через `fb_lookup()`.

#### Поддерживаемые платформы
* STM32F7Discovery
* i.MX6 LVDS
* EFM32 LCD display
* PL110 for IntegratorCP
* BOCHS
* Cirrus
