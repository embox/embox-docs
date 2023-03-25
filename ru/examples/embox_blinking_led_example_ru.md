# Пример “Blinking led”

## Библиотека libgpio
В Embox интерфейс GPIO предоставляется библиотекой libgpio. Для использование библиотеки в команде необходимо подключить заголовочный файл ***<drivers/gpio/gpio.h>***.

Библиотека имеет следующий интерфейс:

* int gpio_setup_mode(unsigned short port, gpio_mask_t pins, int mode) - функция задания режима работы вывода. Режим может быть одним из следующих:

	Некоторые базовые режимы (см. <drivers/gpio/gpio.h>):
    * GPIO_MODE_OUTPUT - режим вывода
    * GPIO_MODE_INPUT - режим ввода
    * GPIO_MODE_INT_MODE_RISING - режим прерывания
    * GPIO_MODE_ALTERNATE - режим Alternate. При этом номер функции может быть выставлен с помощью GPIO_ALTERNATE(num). То есть, в итоге режим будет вида GPIO_MODE_ALTERNATE | GPIO_ALTERNATE(num).
* void gpio_set(unsigned short port, gpio_mask_t pins, char level) - установить значение на выходе. Режим вывода должен быть GPIO_MODE_OUTPUT.
* void gpio_toggle(unsigned short port, gpio_mask_t pins) - инвертировать значение на выходе. Режим вывода должен быть GPIO_MODE_OUTPUT.
* gpio_mask_t gpio_get(unsigned short port, gpio_mask_t pins) - получить значение на входе. Результат представляется в виде маски. Режим вывода должен быть GPIO_MODE_INPUT.
* int gpio_irq_attach(unsigned short port, gpio_mask_t pins, irq_handler_t pin_handler, void *data) - задание обработчика прерывания. Режим вывода должен быть GPIO_MODE_INT_MODE_RISING.

## Простое мигание диодом
Данный пример демонстрирует исходный код простейшего приложения которое в цикле мигает светодиодом для платы STM32F4discovery. В данном разделе разбирается только исходный код на языке Си. Как добавить описание модуля и включить приложение в текущую конфигурацию описано в разделе "Пример “Hello World”"

Светодиод подключен к выводу 12 порта D в примере используются именно эти значения для простоты и понятности. Номера портов могут быть переданы как через аргументы командной строки, так и через опции модуля ( см. раздел "Опции модуля"), либо заданы для конкретной платы самостоятельно.

```c
#include <unistd.h>

#include <drivers/gpio/gpio.h>

#define LED4_PIN        (1 << 12)

int main(int argc, char *argv[]) {
    int cnt;

    gpio_setup_mode(GPIO_PORT_D, LED4_PIN, GPIO_MODE_OUTPUT);
    gpio_set(GPIO_PORT_D, LED4_PIN, 0);

    for(cnt = 0; cnt < 100; cnt++) {
        sleep(1);
        gpio_toggle(GPIO_PORT_D, LED4_PIN);
    }

    return 0;
}
```

Перед использованием вывод нужно проинициализировать, задать режим выхода, с помощью функции ***gpio_setup_mode()***. Затем устанстанавливается начальное значение 0.
Далее идет цикл до 100 переключений, в котором происходит задержка на 1 секунду и инвертируется значение на выходе.

## Переключение светодиода как реакция на нажатие кнопки

Данный пример демонстрирует исходный код приложения которое переключает состояние сведодиода по нажатию кнопки для платы STM32F4discovery.

Как и в случае с предыдущим примером состояние выводов определено схематикой, задано константами прямо в коде и может быть изменено описанными способами.

```c
#include <unistd.h>

#include <drivers/gpio/gpio.h>

#define LED4_PIN        (1 << 12)
#define USER_BUTTON_PIN (1 << 0)

void user_button_hnd(void *data) {
    gpio_toggle(GPIO_PORT_D, LED4_PIN);    
}

int main(int argc, char *argv[]) {
    gpio_setup_mode(GPIO_PORT_D, LED4_PIN, GPIO_MODE_OUTPUT);
    gpio_setup_mode(GPIO_PORT_A, USER_BUTTON_PIN,
		GPIO_MODE_INT_MODE_RISING);

    gpio_set(GPIO_PORT_D, LED4_PIN, 0);

    if (0 > gpio_irq_attach(GPIO_PORT_A, USER_BUTTON_PIN,
			user_button_hnd, NULL)) {
        return -1;
    }

    sleep(30);

    return 0;
}
```

Отличие от примера с простым миганием светодиодом заключается в использовании еще одного вывода, который переключен в режим прерывания с помощью функции gpio_setup_mode(). А с помощью функции gpio_irq_attach() на событие по изменению состояния на выводе подключенном к кнопке, повешен обработчик. В обработчике происходит инвертирование значения на выходе светодиода.

