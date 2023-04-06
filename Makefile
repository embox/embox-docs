

all: ru en

user_manual_en:
	pandoc --template=embox_pandoc.latex \
	en/headers/embox_user_manual_header_en.md \
	en/embox_quick_overview_en.md \
	en/embox_quick_start_en.md \
	en/embox_modular_structure_en.md \
	en/embox_build_en.md
	en/platforms/embox_supported_platforms_en.md \
	en/platforms/embox_supported_platforms_qemu_en.md \
	en/platforms/embox_supported_platforms_x86_en.md \
	en/platforms/embox_supported_platforms_arm_en.md \
	en/drivers/embox_drivers_en.md \
	en/drivers/embox_drivers_framebuffer_en.md \
	en/drivers/embox_drivers_flash_en.md \
	en/drivers/embox_drivers_gpio_en.md \
	en/drivers/embox_drivers_i2c_en.md \
	en/examples/embox_examples_light_sensor_stm32_en.md \
	en/examples/embox_examples_opencv_stm32_en.md \
	en/examples/embox_examples_pjsip_stm32_en.md \
	en/examples/embox_examples_qt_stm32_en.md \
	en/libs/embox_lib_fps_en.md \
	en/embox_user_manual_en.md \
	-o embox_user_manual_en.pdf

quick_start_en:
	pandoc --template=embox_pandoc.latex \
	en/headers/embox_quick_start_header_en.md \
	en/embox_quick_overview_en.md \
	en/embox_quick_start_en.md \
	-o embox_quick_start_en.pdf

quick_overview_en:
	pandoc --template=embox_pandoc.latex \
	en/headers/embox_quick_overview_header_en.md \
	en/embox_quick_overview_en.md \
	-o embox_quick_overview_en.pdf


user_manual_ru:
	pandoc --template=embox_pandoc.latex \
	ru/headers/embox_user_manual_header_ru.md \
	ru/embox_quick_overview_ru.md \
	ru/embox_quick_start_ru.md \
	ru/embox_modular_structure_ru.md \
	ru/embox_build_ru.md \
	ru/embox_execute_debug_ru.md \
	ru/examples/embox_hello_world_example_ru.md \
	ru/examples/embox_blinking_led_example_ru.md \
	ru/examples/embox_external_app_example_ru.md \
	ru/embox_cxx_support_ru.md \
	ru/platforms/embox_supported_platforms_ru.md \
	ru/platforms/embox_supported_platforms_qemu_ru.md \
	ru/platforms/embox_supported_platforms_x86_ru.md \
	ru/platforms/embox_supported_platforms_arm_ru.md \
	ru/drivers/embox_drivers_ru.md \
	ru/drivers/embox_drivers_diag_ru.md \
	ru/drivers/embox_drivers_interrupt_controllers_ru.md \
	ru/drivers/embox_drivers_timers_ru.md \
	ru/drivers/embox_drivers_serials_ru.md \
	ru/drivers/embox_drivers_input_ru.md \
	ru/drivers/embox_drivers_ethernet_cards_ru.md \
	ru/drivers/embox_drivers_framebuffers_ru.md \
	ru/drivers/embox_drivers_flash_ru.md \
	ru/drivers/embox_drivers_pci_ru.md \
	ru/drivers/embox_drivers_devfs_ru.md \
	-o embox_user_manual_ru.pdf

quick_start_ru:
	pandoc --template=embox_pandoc.latex \
	ru/headers/embox_quick_start_header_ru.md \
	ru/embox_quick_overview_ru.md \
	ru/embox_quick_start_ru.md \
	-o embox_quick_start_ru.pdf

quick_overview_ru:
	pandoc --template=embox_pandoc.latex \
	ru/headers/embox_quick_overview_header_ru.md \
	ru/embox_quick_overview_ru.md \
	-o embox_quick_overview_ru.pdf

en: quick_overview_en quick_start_en user_manual_en

ru: quick_overview_ru quick_start_ru user_manual_ru

clean:
	rm -f *.pdf
