
### Таймеры
#### Описание 
Таймеры (clock_source) обеспечивают работу подсистемы времени. Существует два типа устройств time_event_device и time_counter_device. time_event_device отчитывает такты времени по прерыванию и может реализовывать системный jitter.

#### Реализация
Для задания таймера следует использовать макрос CLOCK_SOURCE_DEF(). Данный макрос определяет глобальное имя в системе, функцию инициализации, указатели на структуры time_event_device и time_counter_device и пользовательсткие данные для устройсва.
```
CLOCK_SOURCE_DEF(integratorcp, integratorcp_cs_init, NULL,
	&integratorcp_event_device, &integratorcp_counter_device);
```
Где integratorcp_event_device и integratorcp_counter_device это экземпляры структур time_event_device и time_counter_device соотвественно.

Стурктур time_counter_device позволяет определять устройство времени значение которой нужно запрашивать с помощьюспецильной функции чтения устройства. Данные устройства обладают частотой обновления и максимальным значением внутреннего счетчика
```
struct time_counter_device {
	uint32_t cycle_hz;
	uint64_t mask; /* Maximum value that can be loaded */

	cycle_t (*read)(struct clock_source *cs);
};
```
Структура time_event_device определяет устройство которое вырабатывает прерывание через определенный промежуток времени. В обработчике прерываний должен присуствовать вызов функции clock_tick_handler(). В качестве параметра должен передаваться указатель на структуру clock_source который стал источником прерывания.

```
struct time_event_device {
	int (*set_oneshot)(struct clock_source *cs);
	int (*set_periodic)(struct clock_source *cs);
	int (*set_next_event)(struct clock_source *cs, uint32_t next_event);

	uint32_t flags; /**< periodical or not */

	volatile clock_t jiffies; /**< count of jiffies since event device started */

	uint32_t event_hz;
};

```
Две основные функции для управления прерываниями set_periodic() и set_next_event(). set_periodic указывает что необходимо вырабатывать прерывания с частотой event_hz. set_next_event() позволяет задать время срабатывания следующего прерывания, используется когда выработка прерываний требуется с неравномерной переодичностью.

