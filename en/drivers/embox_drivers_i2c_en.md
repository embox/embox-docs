## I2C
### User space API
#### Read operation
Use `i2c_bus_read()` to read from I2C device:
```
ssize_t i2c_bus_read(int id, uint16_t addr, uint8_t *ch, size_t sz);
```
where:
* id -- bus number;
* addr -- chip address on bus;
* ch -- buffer for reading
* sz -- buffer size

On success, the number of bytes read is returned. Otherwise negative error code is returned.

#### Write operation
Use `i2c_bus_write()` to write to I2C device:
```
ssize_t i2c_bus_write(int id, uint16_t addr, const uint8_t *ch, size_t sz);
```
where:
* id -- bus number;
* addr -- chip address on bus;
* ch -- buffer for writing
* sz -- buffer size

On success, the number of bytes written is returned. Otherwise negative error code is returned.

#### Scanning available I2C buses
Calling `i2c_bus_write()` with `sz == 0` can be used to check if device is available.

### I2C adapters
To add I2C support for a new platform you have to add `struct i2c_adapter` and pass it to `i2c_bus_register()`. Operations are described in `struct i2c_algorithm` as `i2c_master_xfer` routine. One of arguments is pointer to i2c_msg structure. Direction of operation  (read/write) is coded in `flags` field from i2c_msg. If flag `I2C_M_RD` set than this is read operation otherwise write.

#### Supported I2C adapters

* [[STM32 MCU Eval Tools]]
* [[i.MX6]]

