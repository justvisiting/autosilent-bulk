DEV = /Developer/Platforms/iPhoneOS.platform/Developer

SDK = $(DEV)/SDKs/iPhoneOS2.2.1.sdk

CC = $(DEV)/usr/bin/gcc-4.0

#CC = $(DEV)/gcc

#LD = $(CC)
#LDFLAGS = -lobjc \
#          -framework CoreFoundation \
#         -framework Foundation
#

CFLAGS = -arch arm \
	-g -O2 -Wall \
	-I"$(SDK)/usr/include" \
	-I"$(DEV)/usr/lib/gcc/arm-apple-darwin9/4.0.1/include" \
	-F"$(SDK)/System/Library/Frameworks"\
	-F"$(SDK)/System/Library/PrivateFrameworks" \
	-DMAC_OS_X_VERSION_MAXALLOWED=MAC_OS_X_VERSION_10_5 \
	-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_5

CFLAGS += -I"/Developer/SDKs/iPhoneOS.sdk/Versions/iPhoneOS2.0.sdk/include"
CFLAGS += -dynamiclib

LD = $(CC)

LDFLAGS = -arch arm -lobjc
LDFLAGS += -framework CoreFoundation
LDFLAGS += -framework Foundation
LDFLAGS += -framework AVFoundation
LDFLAGS += -framework UIKit
#LDFLAGS += -framework LayerKit
LDFLAGS += -framework QuartzCore
#LDFLAGS += -framework CoreAnimation
LDFLAGS += -framework IOKit
LDFLAGS += -framework CoreGraphics
LDFLAGS += -framework GraphicsServices
LDFLAGS += -framework CoreSurface
LDFLAGS += -framework CoreAudio
LDFLAGS += -framework OpenAL
LDFLAGS += -framework Celestial
LDFLAGS += -framework AudioToolbox
LDFLAGS += -framework AppSupport
LDFLAGS += -framework Calendar
LDFLAGS += -framework Security
LDFLAGS += -framework CoreTelephony
LDFLAGS += -L"$(SDK)/usr/lib"
LDFLAGS += -F"$(SDK)/System/Library/Frameworks"
#LDFLAGS += -F"$(SDK)/System/Library/Frameworks/IOKit.framework/Versions/A"
LDFLAGS += -F"$(SDK)/System/Library/PrivateFrameworks"
LDFLAGS += "$(SDK)/usr/lib/libsqlite3.0.dylib" 
LDFLAGS += "$(DEV)/usr/lib/libsubstrate.dylib"
LDFLAGS += -DMAC_OS_X_VERSION_MAXALLOWED=MAC_OS_X_VERSION_10_5 
LDFLAGS += -DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_5 
LDFLAGS += -dynamiclib \
				-init _ExampleHookInitialize \
				-Wall \
				-Werror \
				-lsubstrate \
				-lobjc \
				-ObjC++ \
				-fobjc-exceptions \
				-march=armv6 \
				-mcpu=arm1176jzf-s \
				-fobjc-call-cxx-cdtors

Objects= ExampleHookLibrary.o RevolverSound.o Sound+IO.o Sound.o Finch.o

Target=ExampleHook.dylib


all:	$(Target) install

IP  = 192.168.1.107

install:
		scp $(Target) root@$(IP):/var/root
#		ssh roo@$(IP) chmod 755 $(Target)
#		ssh root@$(IP) ldid -S $(Target) 
#		ssh $(IP) mv $(Target) /Library/MobileSubstrate/DynamicLibraries
#		ssh $(IP) killall SpringBoard

$(Target):	$(Objects)
		$(CC) $(LDFLAGS) -o $@ $^

%.o:	%.mm
		$(CC) -c $(CFLAGS) $< -o $@

%.o:       %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

%.o:       %.cpp
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

package:

clean:
	rm -f *.o *.gch $(EXE)
	rm -f ./$(EXE).app/$(EXE)

scan: 
	./infoscanner Info.plist anticrack_scan_result.h
