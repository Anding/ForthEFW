UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

ifeq ($(UNAME_S),Darwin)
    platform = mac
else
    ifeq ($(UNAME_M),x86_64)
        platform = x64
    else
        platform = x86
    endif
endif

CC = g++

ifeq ($(platform), mac32)
CFLAGS += -m32 -framework IOKit -framework CoreFoundation

endif

ifeq ($(platform), mac64)

CFLAGS += -framework IOKit -framework CoreFoundation
endif

ifeq ($(platform), mac)
CFLAGS += -arch x86_64 -framework IOKit -framework CoreFoundation -framework AppKit
endif

ifeq ($(platform), x86)
CFLAGS += -ludev
LIBS += -ldl
endif


ifeq ($(platform), x64)
CFLAGS += -m64
CFLAGS += -ludev
LIBS += -ldl
endif

ifeq ($(platform), armv5)
CFLAGS += -ludev
endif


ifeq ($(platform), armv6)
CFLAGS += -ludev

endif

ifeq ($(platform), armv8)
CFLAGS += -ludev

endif

all:usb_test_console
usb_test_console: efw_test.cpp
	$(CC) efw_test.cpp -o test_console $(CFLAGS) ../../lib/$(platform)/libEFWFilter.a -I../../include $(CFLAGS) -lpthread $(LIBS)
	-mkdir -p bin/$(platform)/
	cp test_console bin/$(platform)/
clean:
	rm -f test_console


