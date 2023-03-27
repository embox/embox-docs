# FPS: Полезная библиотека для вывода видео

Из названия библиотеки (FPS -- «frame-per-second») следует, что её можно использовать для подсчёта кадров в секунду. Но она также имеет ряд функций, которые могут помочь Вам в работе с графическим выводом.«»

## Интерфейс

Название модуля -- `embox.lib.fps`, поэтому Вам следует или добавить `depends embox.lib.fps` в Ваш модуль «Mybuild», или явно вставить `include embox.lib.fps` в `conf/mods.conf` (хотя второй вариант использовать не рекомендуется).

Заголовочный файл: `#include <fps/fps.h>`.

## Основное применение

Для начала убедитесь, что Вы знакомы с интерфейсом фрейм-буфера: [[Frame buffer]].

После того, как Вы получили `struct fb_info *`, Вы можете использовать FPS-библиотеку так же просто, как в следующем примере:
```c
  struct fb_info *fbi = fb_lookup(0);
  fps_set_format("Hello, world!");
  fps_print(fbi);
```

Теперь надпись `Hello, world!` должна появиться в левом верхнем углу экрана. Да, это не выглядит как что-то полезное, поэтому давайте выведем на экран фактическую скорость кадров в секунду:

```c
  struct fb_info *fbi = fb_lookup(0);
  /* Формат по умолчанию -- «Embox FPS=%d» */
  fps_set_format("Hello, world!\nFPS=%d"); /* \n работает в случае с format string */
  while(1) {
        fps_print(fbi);
        msleep(100);
  }
```

Теперь на экране (на второй строчке) должна появиться надпись наподобие «FPS=10».

## Double buffering

Sometimes rendering scene takes a lot of time, so if we draw directly to frame buffer base, glitches will appear on the screen. Double buffering is a technique that can solve this problem.

The idea is to store additional "back" buffer for drawing, while main frame remains unchanged.

The first way to use it is as follows:
```c
struct fb_info *fbi = fb_lookup(0);

fps_enable_swap(fbi);

while (1) {
        uint8_t *current_frame = fps_current_frame_fbi);
        draw_something(current_frame);
        fps_print(fbi);
        /* Move content of the back buffer to screen */
        fps_swap(fbi);
}
```

Things can be more tricky if you want frame to be placed in certain memory area (for example, if it's special device-specific memory for temporary buffer). In this case you can set frame base manually with following functions:

```c
  void fps_set_base_frame(struct fb_info *fb, void *base_frame);
  void fps_set_back_frame(struct fb_info *fb, void *base_back_frame);

  /* Minimal example may look like this */
  struct fb_info *fbi = fb_lookup(0);

  fps_set_base_frame(fbi, some_addr_1);
  fps_set_back_frame(fbi, some_addr_2);

  while (1) {
        uint8_t *current_frame = fps_current_frame_fbi);
        draw_something(current_frame);
        fps_print(fbi);

        /* Move content of the back buffer to screen */
        fps_swap(fbi);
  }
```

NOTE: This will work in a correct way only if given FB supports changing base of the frame buffer. Otherwise, only "simple" double-buffering example will work.
