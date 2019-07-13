## GPIO

### User API

File `drivers/gpio/gpio.h`:

* `int gpio_setup_mode(unsigned short port, gpio_mask_t pins, int mode)`

   Setup mode for the specified pins at GPIO port. You should to check return value of this function to make sure the specified port is available.

   Parameters:
    * port -- combination of GPIO port and GPIO controller number.

        For example, it can be `GPIO_CHIP0 | GPIO_PORT_B`. But currently, we use only one GPIO controller, so usually, you can just write `GPIO_PORT_B` instead.
    * pins -- mask of pins for which `mode` will be set up
    * mode -- `GPIO_MODE_OUTPUT` for output, `GPIO_MODE_INPUT` for input,  `GPIO_MODE_INT_MODE_RISING` if you want to use interrupts, etc. (see drivers/gpio/gpio.h)

    Return value:
    *  0 on success. Negative value will be returned in case if the corresponding GPIO port is not presented.

* `void gpio_set(unsigned short port, gpio_mask_t pins, char level)`

    Set up the selected pins into high or low states.

    Parameters:
    * port -- combination of GPIO port and GPIO controller number (usually, `GPIO_PORT_A`, `GPIO_PORT_B`, etc.)
    * pins -- mask of pins for which `mode` will be set up
    * level -- boolean value. When it is non-zero the pins will be set up high. You can also use these macros `GPIO_PIN_LOW` and `GPIO_PIN_HIGH` as level value.

* `void gpio_toggle(unsigned short port, gpio_mask_t pins)`

    Invert state of the specified pins (that is, toggles them).

    Parameters:
    * port -- combination of GPIO port and GPIO controller number (usually, `GPIO_PORT_A`, `GPIO_PORT_B`, etc.)
    * pins -- mask of pins which will be toggled.

* `gpio_mask_t gpio_get(unsigned short port, gpio_mask_t pins)`

    Get state of he specified pins.

    Parameters:
    * port -- combination of GPIO port and GPIO controller number (usually, `GPIO_PORT_A`, `GPIO_PORT_B`, etc.)
    * pins -- mask of pins for which state will be returned

    Return value:
    * Mask of pins states.

* `int gpio_irq_attach(unsigned short port, gpio_mask_t pins, irq_handler_t pin_handler, void *data)`

    Attach interrupt handler to the specified port and pins. These port and pins must be configured with `gpio_setup_mode` firstly to allow interrupts. Then, when GPIO interrupt happens, pin_handler will be called.

    Parameters:
    * port -- combination of GPIO port and GPIO controller number (usually, `GPIO_PORT_A`, `GPIO_PORT_B`, etc.)
    * pins -- mask of pins for which irq handler will be registered
    * pin_handler -- interrupt handler
    * data -- data that will be passed to pin_handler

    Return value:
    * 0 on success.

#### Examples

* Toggle LED with button on STM32F4-Discovery
```
#include <unistd.h>
#include <kernel/irq.h>
#include <drivers/gpio/gpio.h>

#define LED4_PIN        (1 << 12)
#define USER_BUTTON_PIN (1 << 0)

irq_return_t user_button_hnd(unsigned int irq_nr, void *data) {
    gpio_toggle(GPIO_PORT_D, LED4_PIN);
    return IRQ_HANDLED;
}

int main(int argc, char *argv[]) {
    gpio_setup_mode(GPIO_PORT_D, LED4_PIN, GPIO_MODE_OUTPUT);
    gpio_setup_mode(GPIO_PORT_A, USER_BUTTON_PIN, GPIO_MODE_INT_MODE_RISING);

    if (0 > gpio_irq_attach(GPIO_PORT_A, USER_BUTTON_PIN, user_button_hnd, NULL)) {
        return -1;
    }

    sleep(30);

    return 0;
}
```


### Driver API

File `drivers/gpio/gpio_driver.h`:

Each GPIO driver should define structure:

```
struct gpio_chip {
    int (*setup_mode)(unsigned char port, gpio_mask_t pins, int mode);
    void (*set)(unsigned char port, gpio_mask_t pins, char level);
    gpio_mask_t (*get)(unsigned char port, gpio_mask_t pins);
    unsigned char nports;
};
```

Fields description:

    * setup_mode -- corresponds to gpio_setup_mode from User API
    * set -- corresponds to gpio_set from User API
    * get -- corresponds to gpio_get from User API
    * nports - number of GPIOs in this GPIO controller. For example, if controller provides GPIOA, GPIOB, GPIOC, then nports must be equal 3.

* `int gpio_register_chip(struct gpio_chip *gpio_chip, unsigned char chip_id)`

    Register controller in a global GPIO controllers array.

* `void gpio_handle_irq(struct gpio_chip *gpio_chip, unsigned int irq_nr, unsigned char port, gpio_mask_t changed_pins)`

    This function notify global GPIO module about interrupt. Usually, it should be called from the driver's internal interrupt handler.

### Supported controllers

* [[STM32 MCU Eval Tools]]
* [[i.MX6]]
* Qemu ARM OMAP3 Overo
* [Bifferboard](https://github.com/embox/embox/wiki/Platform-Bifferboard)
