#IP  = 10.81.176.34
IP=192.168.1.101

DEV = /Developer/Platforms/iPhoneOS.platform/Developer

SDK = $(DEV)/SDKs/iPhoneOS4.2.sdk

SDK30 = $(DEV)/SDKs/iPhoneOS4.2.sdk

CC = $(DEV)/usr/bin/gcc-4.2

#CC = $(DEV)/gcc

#LD = $(CC)
#LDFLAGS = -lobjc \
#          -framework CoreFoundation \
#         -framework Foundation
#

CFLAGS = -arch armv6 \
	-I"$(SDK)/usr/include" \
	-I"$(DEV)/usr/lib/gcc/arm-apple-darwin10/4.0.1/include" \
	-I"$(SDK30)/usr/include"\
	-F"$(SDK)/System/Library/Frameworks"\
	-F"$(SDK30)/System/Library/Frameworks"\
	-F"$(SDK)/System/Library/PrivateFrameworks" \
	-DMAC_OS_X_VERSION_MAXALLOWED=MAC_OS_X_VERSION_10_5 \
	-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_5


CFLAGS += -I"$(SDK)/include"
#CFLAGS += -I"/Developer/SDKs/iPhoneOS.sdk/Versions/iPhoneOS2.0.sdk/include"
CFLAGS += -I"/Users/neha/vishal/include"

LD = $(CC)

LDFLAGS = -arch armv6 -lobjc -O3
LDFLAGS += -framework CoreFoundation
LDFLAGS += -framework Foundation
LDFLAGS += -framework UIKit
#LDFLAGS += -framework LayerKit
LDFLAGS += -framework QuartzCore
#LDFLAGS += -framework CoreAnimation
LDFLAGS += -framework IOKit
LDFLAGS += -framework CoreGraphics
LDFLAGS += -framework GraphicsServices
LDFLAGS += -framework CoreSurface
LDFLAGS += -framework CoreAudio
LDFLAGS += -framework Celestial
LDFLAGS += -framework AudioToolbox
LDFLAGS += -framework AppSupport
#LDFLAGS += -framework Calendar
LDFLAGS += -framework Security
LDFLAGS += -framework CoreTelephony
LDFLAGS += -framework MediaPlayer
LDFLAGS += -framework EventKit
LDFLAGS += -L"$(SDK)/usr/lib"
LDFLAGS +=  -F"$(SDK30)/System/Library/Frameworks"
LDFLAGS += -F"$(SDK)/System/Library/Frameworks"
#LDFLAGS += -F"$(SDK)/System/Library/Frameworks/IOKit.framework/Versions/A"
LDFLAGS += -F"$(SDK)/System/Library/PrivateFrameworks"
LDFLAGS += "$(SDK)/usr/lib/libsqlite3.0.dylib" 
LDFLAGS += -DMAC_OS_X_VERSION_MAXALLOWED=MAC_OS_X_VERSION_10_5 
LDFLAGS += -DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_5 
	
EXE = SilentMed


all:  $(EXE) package install

$(EXE):	$(EXE).o FMDatabase.o FMDatabaseAdditions.o FMResultSet.o \
calendar.o powerMgmt.o \
Base64TransCoder.o Notifications.o \
BaseEvent.o logger.o configManager.o settingsManager.o scheduler.o \
scheduleInfo.o profile.o Common.o NightTime.o Base64TransCoder.o 
	$(LD) $(LDFLAGS) -o $@ $^

%.o:       %.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

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
                                
install:
	scp $(EXE) root@$(IP):/Applications/SilentMe.app/

