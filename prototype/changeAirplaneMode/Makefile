DEV = /Developer/Platforms/iPhoneOS.platform/Developer

SDK = $(DEV)/SDKs/iPhoneOS2.0.sdk

CC = $(DEV)/usr/bin/gcc-4.0

#CC = $(DEV)/gcc

#LD = $(CC)
#LDFLAGS = -lobjc \
#          -framework CoreFoundation \
#         -framework Foundation
#

CFLAGS = -arch arm \
	-I"$(SDK)/usr/include" \
	-I"$(DEV)/usr/lib/gcc/arm-apple-darwin9/4.0.1/include" \
	-F"$(SDK)/System/Library/Frameworks"\
	-F"$(SDK)/System/Library/PrivateFrameworks" \
	-DMAC_OS_X_VERSION_MAXALLOWED=MAC_OS_X_VERSION_10_5 \
	-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_5

LD = $(CC)

LDFLAGS = -arch arm -lobjc \
	-framework Celestial \
	-framework CoreFoundation \
	-framework Foundation \
	-framework UIKit \
	-framework AudioToolbox \
	-framework CoreAudio \
	-framework GraphicsServices \
	-framework CoreTelephony \
	"$(SDK)/usr/lib/libsqlite3.0.dylib" \
	-L"$(SDK)/usr/lib" \
	-F"$(SDK)/System/Library/Frameworks" \
	-F"$(SDK)/System/Library/PrivateFrameworks" \
	-DMAC_OS_X_VERSION_MAXALLOWED=MAC_OS_X_VERSION_10_5 \
	-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_5 \
	
EXE = sbCustom

all:  $(EXE) install

$(EXE):	$(EXE).o   
	$(LD) $(LDFLAGS) -o $@ $^

%.o:       %.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

%.o:       %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

%.o:       %.cpp
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

package:
	cp -p $(EXE) ./$(EXE).app

clean:
	rm -f *.o *.gch $(EXE)
	rm -f ./$(EXE).app/$(EXE)

IP = 192.168.1.107

install:
	scp $(EXE) root@$(IP):./
