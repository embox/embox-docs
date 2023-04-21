# Running OpenCV on STM32F7Discovery

This section describes some experimental stuff, so there are chances that something doesn't work as expected. Feel free to create new [issues](https://github.com/embox/embox/issues), we'll try to figure it out.

Currently OpenCV works with [STM32F746GDISCOVERY](https://www.st.com/en/evaluation-tools/32f746gdiscovery.html) and [STM32F769IDISCOVERY](https://www.st.com/en/evaluation-tools/32f769idiscovery.html).

Following examples describe how to run example Canny filter to detect edges (source code is `platform/opencv/cmds/edges.cpp` in Embox).

## STM32F769IDISCOVERY
This board has enough flash memory for OpenCV, so it's pretty easy to run a simple example:

1. Compile this template (it requires a few minutes as it builds libstdc++ and opencv from source)
```
 	make confload-platform/opencv/stm32f769i-discovery
 	make
```

2. Load Embox with openocd (more details on [another wiki page](https://github.com/embox/embox/wiki/STM32F7DISCOVERY))

3. Run `edges 20` on Embox console


## STM32F746GDISCOVERY
This board has only 1MiB flash memory, so it's a little bit more compilated. OpenCV requires too much read-only memory (it's mostly code), so you have to use QSPI flash to run it.

Brief instruction:

1. Compile this template:
```
 	make confload-platform/opencv/stm32f764g-discovery
 	make
```
2. Extract readonly sections from ELF
```
	arm-none-eabi-objcopy -O binary build/base/bin/embox tmp.bin \
		--only-section=.text --only-section=.rodata \
		--only-section='.ARM.ex*' \
		--only-section=.data
```

3. Now load `tmp.bin` to QSPI memory. Refer to https://github.com/embox/embox/wiki/STM32F7DISCOVERY#loading-files-to-qspi for more details

4. Use `goto` command, jump to target memory address. Target address is a second 32-bit word of the binary image (you can find it out with `mem -a 0x90000004`).

5. Run `edges 20` on Embox console

![](https://raw.githubusercontent.com/wiki/embox/embox/images/platforms/stm32f7-opencv.jpg)

