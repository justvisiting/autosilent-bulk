IP  = 192.168.1.101

DEV = /Developer/Platforms/iPhoneOS.platform/Developer

SDK = $(DEV)/SDKs/iPhoneOS2.2.1.sdk

SDK30 = $(DEV)/SDKs/iPhoneOS3.0.sdk

CC = $(DEV)/usr/bin/gcc-4.0

#CC = $(DEV)/gcc

#LD = $(CC)
#LDFLAGS = -lobjc \
#          -framework CoreFoundation \
#         -framework Foundation
#

CFLAGS = -arch arm \
	-O3 -Wall \
	-I"$(SDK)/usr/include" \
	-I"$(DEV)/usr/lib/gcc/arm-apple-darwin9/4.0.1/include" \
	-I"$(SDK30)/System/Library/Frameworks/MediaPlayer.framework/Headers"\
	-F"$(SDK)/System/Library/Frameworks"\
	-F"$(SDK30)/System/Library/Frameworks"\
	-F"$(SDK)/System/Library/PrivateFrameworks" \
	-DMAC_OS_X_VERSION_MAXALLOWED=MAC_OS_X_VERSION_10_5 \
	-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_5

CFLAGS += -I"$(SDK)/include"
#CFLAGS += -I"$(SDK30)/usr/include"
CFLAGS += -I"/Developer/SDKs/iPhoneOS.sdk/Versions/iPhoneOS2.0.sdk/include"
CFLAGS += -dynamiclib

LD = $(CC)

LDFLAGS = -arch arm -lobjc -O3
#LDFLAGS += -framework MeCCA
#LDFLAGS += -framework AppSupport
LDFLAGS += -framework CoreFoundation
LDFLAGS += -framework Foundation
LDFLAGS += -framework AVFoundation
LDFLAGS += -framework UIKit
#LDFLAGS += -framework LayerKit
LDFLAGS += -framework QuartzCore
#LDFLAGS += -framework CoreAnimation
#LDFLAGS += -framework IOKit
LDFLAGS += -framework CoreGraphics
#LDFLAGS += -framework GraphicsServices
#LDFLAGS += -framework CoreSurface
#LDFLAGS += -framework CoreAudio
#LDFLAGS += -framework OpenAL
#LDFLAGS += -framework Message
LDFLAGS += -framework Celestial
LDFLAGS += -framework AudioToolbox
#LDFLAGS += -framework AppSupport
#LDFLAGS += -framework Calendar
LDFLAGS += -framework Security
LDFLAGS += -framework CoreTelephony
LDFLAGS += -framework MediaPlayer
LDFLAGS += -L"$(SDK)/usr/lib"
LDFLAGS += -F"/Users/god/depot5/mobileSubstratePlugin"
LDFLAGS +=  -F"$(SDK30)/System/Library/Frameworks"
LDFLAGS += -F"$(SDK)/System/Library/Frameworks"
#LDFLAGS += -F"$(SDK)/System/Library/Frameworks/IOKit.framework/Versions/A"
LDFLAGS += -F"$(SDK)/System/Library/PrivateFrameworks"
LDFLAGS += "$(SDK)/usr/lib/libsqlite3.0.dylib" 
LDFLAGS += "$(DEV)/usr/lib/libsubstrate.dylib"
LDFLAGS += -DMAC_OS_X_VERSION_MAXALLOWED=MAC_OS_X_VERSION_10_5 
LDFLAGS += -DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_5 
LDFLAGS += -dynamiclib 
LDFLAGS += -init _AutoSilentInitialize 
LDFLAGS += -Wall 
LDFLAGS += -Werror 
LDFLAGS += -lsubstrate 
LDFLAGS += -lobjc 
LDFLAGS += -ObjC++ 
LDFLAGS += -fobjc-exceptions 
LDFLAGS += -march=armv6 
LDFLAGS += -mcpu=arm1176jzf-s 
#LDFLAGS += -fobjc-call-cxx-cdtors

constants.h:
	cp ../newdaemonScript/constants.h .

configManager.m: constants.h logger.m
	cp ../newdaemonScript/configManager.* .   

logger.m:  constants.h                           
	cp ../newdaemonScript/logger.* .

Objects= AutoSilent.o PerformVibration.o Log.o configManager.o logger.o

Target= AutoSilent.dylib


all: clean $(Target) install


install:
		scp $(Target) root@$(IP):/var/root
#		ssh roo@$(IP) chmod 755 $(Target)
#		ssh root@$(IP) ldid -S $(Target) 
#		ssh $(IP) mv $(Target) /Library/MobileSubstrate/DynamicLibraries
#		ssh $(IP) killall SpringBoard

$(Target):	$(Objects)
		$(CC) $(LDFLAGS) -o $@ $^

%.o:    %.m
		$(CC) -c $(CFLAGS) $< -o $@

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
