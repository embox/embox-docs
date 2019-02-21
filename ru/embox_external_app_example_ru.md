# Пример стороннего приложения
Данный пример демонстрирует как подключить к сборке сторонний проект с открытым кодом.

Для примера разберем добавление редактора 'nano'

Как и в случае с другими приложениями, необходимо добавить описание модуля

```
    package third_party.cmd

    @App
    @AutoCmd
    @Build(stage=2,script="$(EXTERNAL_MAKE)")
    @Cmd(name = "nano",
    	help = "Text editor",
    	man = '''
    		NAME
    			nano - Nano's ANOther editor
    		SYNOPSIS
    			nano [OPTIONS] [[+LINE,COLUMN] FILE]...
    		AUTHORS
    			Ilia Vaprol - Adaptation for Embox
    	''')
    module nano {
    	source "^BUILD/extbld/^MOD_PATH/install/nano.o"
    
    	@NoRuntime depends embox.compat.posix.regex

    	depends embox.compat.posix.LibCurses
    }

```

Отличием описание данного модуля от описания обычного приложения являются два аспекта:

* Наличие аннотации @Build позволяющего задать некоторые детали процесса сборки модуля
* В качестве файла исходного кода используется объектный файл

## Аннотация @Build
Аннотация @Build позволяет задавать некоторые детали процесса сборки модуля к которому применена данная аннотация.

### Стадия сборки
Сборка Embox происходит в несколько стадий. Некоторые модули требуют предварительно подготовленного окружения. Например, если модулю требуются стандартная библиотека и собранные библиотеки из внешних репозиторий. Опция stage позволяет задать стадию сборки. Нулевая стадия включает в себя сборку стандартной библиотеки и ядра ОС. Начиная с первой стадии используется компилятор в котором в качестве библиотек используются собранные библиотеки с нулевой стадии. Вторая стадия используется для приложений которым требуется какое то собранное окружение.

### Задание внешнего скрипта сборки
С помощью аннотации @Build можно задавать свои правила для сборки. В том числе можно указать, часто используемый Makefile который позволяет задавать три цели (configure, build, install) (по аналогии с configure, make, make install). Для использования в качестве опции к аннотации нужно использовать

```
    script="$(EXTERNAL_MAKE)"
```

При использовании данного скрипта происходит выполнение makefile находящегося в данной директории.

Для того чтобы использовать разработанные скрипты упрощающие включение стронего приложение можно использовать скрипт EXTBLD_LIB. Для этого необходимо включить эту библиотеку в makefile

```
    ...
    include $(EXTBLD_LIB)
    ...
```

При подключении происходит скачивание архива, проверка контрольной суммы md5, накладывание патчей и затем выполнение целей
```
    $(CONFIGURE) :
    ...
    $(BUILD) :
    ...
    $(INSTALL) :
    ...
```

для использования данного скрипта необходимо задать несколько переменных:

* PKG_SOURCES - название пакета
* PKG_VER - версия пакета
* PKG_SOURCES - url для скачивания
* PKG_MD5 - контрольная сумма md5
* PKG_PATCHES - список файлов с патчами для наложения на оригинальные исходники

```
    PKG_NAME := nano
    PKG_VER  := 2.2.6

    PKG_SOURCES := http://www.nano-editor.org/dist/v2.2/$(PKG_NAME)-$(PKG_VER).tar.gz
    PKG_MD5     := 03233ae480689a008eb98feb1b599807

    PKG_PATCHES := pkg_patch.txt

    include $(EXTBLD_LIB)

    $(CONFIGURE) :
    ...
```

цель $(CONFIGURE), должна перейти с директорию с распакованными и пропатчеными исходниками и затем вызвать конфигуре с требуемыми параметрами:

```
    $(CONFIGURE) :
    	export EMBOX_GCC_LINK=full; \
    	cd $(PKG_SOURCE_DIR) && ( \
    		./configure --host=$(AUTOCONF_TARGET_TRIPLET) \
    			--target=$(AUTOCONF_TARGET_TRIPLET) \
    			--enable-tiny \
    			--disable-shared \
    			--disable-static \
    			--disable-largefile \
    			--disable-rpath \
    			--disable-nls \
    			--disable-extra \
    			--disable-browser \
    			--disable-help \
    			--disable-justify \
    			--disable-mouse \
    			--disable-operatingdir \
    			--disable-speller \
    			--disable-tabcomp \
    			--disable-wrapping \
    			--disable-wrapping-as-root \
    			--disable-color \
    			--disable-multibuffer \
    			--disable-nanorc \
    			--disable-glibtest \
    			CC=$(EMBOX_GCC) \
    	)
    	touch $@
```

цель $(BUILD) должна перейти в папку с исходниками и вызвать make если требуется передать дополнительные флаги.

```
    $(BUILD) :
    	cd $(PKG_SOURCE_DIR) && ( \
    		$(MAKE) MAKEFLAGS='$(EMBOX_IMPORTED_MAKEFLAGS)'; \
    	)
    	touch $@
```
цель  $(INSTALL), должна скопировать результаты сборки в папку для дальнейшей обработки в составе Embox (линковка в конечном образе или использование заголовочных файлов)

```
    $(INSTALL) :
    	cp $(PKG_SOURCE_DIR)/src/nano $(PKG_INSTALL_DIR)/nano.o
    	touch $@
```

## Включение объектных файлов
В конечный образ Embox включаются только те файлы которые указаны в описании модуля, а не все файлы которые получились в процессе сборки стороннего проекта.
Таким образом объектный файл представляющий из себя приложение nano и скопированный в цели $(INSTALL) описанного выше Makefile не будет использоваться, если это не описано в модуле с помощью ключегого слова source:
```
    ...
    module nano {
    	source "^BUILD/extbld/^MOD_PATH/install/nano.o"
        ...
    }

```

В окончательный образ Embox включается бинарный код команды nano и если требуется, линкуется с конечным образом
