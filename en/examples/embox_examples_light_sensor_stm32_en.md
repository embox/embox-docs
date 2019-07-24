# GY 30 I2C light sensor on STM32
[GY-30](https://einstronic.com/store/sensor/light/gy-30-bh1750-ambient-light-sensor-breakout-board-module/) is light intensity sensor which you can connect through I2C to your board.

<img src="https://einstronic.com/wp-content/uploads/2018/06/GY-30-BH1750-Ambient-Light-Sensor-Module-1.jpg" width="320" height="240" align="right">

Here will show how to use this sensor with STM32F4-Discovery board.

* Configure `arm/stm32f4cube` template. Refer to our [guide](https://github.com/embox/embox/wiki/STM32F4DISCOVERY).
* Now edit conf/mods.config:

   * Add I2C driver: `include embox.driver.i2c.stm32_i2c_f4`

   * Add I2C1 bus to which sensor will be connected: `include embox.driver.i2c.stm32_i2c1`

   * Finally, add `gy_30` command to access gy-30: `include embox.cmd.sensors.gy_30`

* Build and flash Embox, then connect with minicom. Refer to our [guide](https://github.com/embox/embox/wiki/STM32F4DISCOVERY) again.
* Connect the sensor sensor to I2C1 bus (GND, VCC, SCL, SDA). You can find corresponding pins in the config file `src/drivers/i2c/adapters/stm32/i2c_conf_f4.h`
* Run `gy_30 -h` for help or `gy_30 -s 1 -m continuous_hres` to see value in Lux printing every second on the screen.

