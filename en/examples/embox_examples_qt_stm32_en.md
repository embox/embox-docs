# Running Qt on STM32F7Discovery

This section describes some experimental stuff, so there are chances that something doesn't work as expected. Feel free to create new issues, we'll try to figure it out.

In this demo we run `moveblocks` Qt animation example on [32F746GDISCOVERY](https://github.com/embox/embox/wiki/STM32F7DISCOVERY).

Watch the video on [Youtube](https://www.youtube.com/watch?v=_BpWQCtW02M).

Brief instruction:

1. Compile this template:
```
 	make confload-arm/qt-stm32f7discovery
 	make
```
2. Extract readonly sections from ELF:
```
	arm-none-eabi-objcopy -O binary build/base/bin/embox qt.bin \
		--only-section=.qt_text \
		--only-section=.qt_rodata \
		--only-section=.qt_data
```

Get Embox ELF without Qt sections:
```
	arm-none-eabi-objcopy build/base/bin/embox embox_qt \
		--remove-section=.qt_text \
		--remove-section=.qt_rodata \
		--remove-section=.qt_data \
		--remove-section=.qt_bss
```


3. Now load `qt.bin` to QSPI memory. Refer to this [guide](https://github.com/embox/embox/wiki/STM32F7DISCOVERY#loading-files-to-qspi) for more details. Exit after qt.bin will be loaded to QSPI.

4. Now load and start embox_qt. Refer to this [guide](https://github.com/embox/embox/wiki/How-to-flash-and-run-STM32-boards) for more details.

