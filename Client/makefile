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
	-O3 \
	-I"$(SDK)/usr/include" \
	-I"$(DEV)/usr/lib/gcc/arm-apple-darwin9/4.0.1/include" \
	-F"$(SDK)/System/Library/Frameworks"\
	-F"$(SDK)/System/Library/PrivateFrameworks"

LD = $(CC)

LDFLAGS = -arch arm -lobjc \
	-framework Celestial \
	-framework CoreFoundation \
	-framework Foundation \
	-framework UIKit \
	-L"$(SDK)/usr/lib" \
        -F"$(SDK)/System/Library/Frameworks" \
	-F"$(SDK)/System/Library/PrivateFrameworks" \

Target = SilentMe

all:	$(Target) install

SilentMe: SilentMeController.o
	$(LD) $(LDFLAGS) -o $@ $^

%.o:       %.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

%.o:       %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

%.o:       %.cpp
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

package:
	cp -p SilentMe ./SilentMe.app

clean:
	rm -f *.o *.gch
	rm -f ./SilentMe.app/SilentMe
	rm SilentMe

IP  = 192.168.1.104
                                
install: 
	scp $(Target) root@$(IP):/Applications/SilentMe.app/

