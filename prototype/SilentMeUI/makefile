IP  = 192.168.1.104

DEV = /Developer/Platforms/iPhoneOS.platform/Developer

#SDK = $(DEV)/SDKs/iPhoneOS2.2.1.sdk
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
	-I"$(DEV)/usr/lib/gcc/arm-apple-darwin10/4.2.1/include" \
	-I"$(SDK30)/usr/include"\
	-F"$(SDK)/System/Library/Frameworks"\
	-F"$(SDK30)/System/Library/Frameworks"\
	-F"$(SDK)/System/Library/PrivateFrameworks" \
	-DMAC_OS_X_VERSION_MAXALLOWED=MAC_OS_X_VERSION_10_5 \
	-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_5 \
        -DIS_IPHONE

CFLAGS += -I"$(SDK)/include"
#CFLAGS += -I"/Developer/SDKs/iPhoneOS.sdk/Versions/iPhoneOS2.0.sdk/include"


LD = $(CC)

LDFLAGS = -arch armv6 -lobjc \
	-framework Celestial \
	-framework CoreFoundation \
	-framework Foundation \
	-framework UIKit \
	-framework CoreGraphics \
	-framework EventKit \
	-L"$(SDK)/usr/lib" \
        -F"$(SDK)/System/Library/Frameworks" \
	-F"$(SDK)/System/Library/PrivateFrameworks" \
        "$(SDK)/usr/lib/libsqlite3.0.dylib" \

Target = SilentMe

all:	$(Target)


SilentMe: SilentMeAppDelegate.o MainTableController.o main.o BaseCell.o \
	ManualTimeSetterController.o Model.o OnOffCell.o Section.o \
	SingletonDataSources.o  ManualTimeCell.o MultipleTimeCell.o \
	BaseController.o ScheduleTimeCell.o ScheduleTimeViewController.o \
	ActivationHelper.o StatusCell.o FixSilentSwitch.o \
        UploadLogsCell.o SendEmailCell.o Schedule.o CalenderSchedule.o \
        BaseDictionary.o Profile.o NameCell.o ProfileListController.o \
        RepeatListController.o SceduleRepeatStringCell.o TextFieldCell.o \
        ScheduleViewController.o ScheduleNameCell.o ProfileViewController.o \
        ProfileNameCell.o TextFieldController.o  ProfileAddController.o \
        FMDatabase.o FMDatabaseAdditions.o FMResultSet.o Calendar.o \
        TextViewCell.o ManualSchedule.o ManualProfileCell.o \
        ManualSchedule.o ManualProfileCell.o CheckmarkCell.o 
	$(LD) $(LDFLAGS) -o $@ $^

ActivationHelper.o: Classes/ActivationHelper.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

SilentMeAppDelegate.o:      Classes/SilentMeAppDelegate.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

MainTableController.o:      Classes/MainTableController.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

main.o:      main.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

BaseCell.o:      Classes/BaseCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@


ManualTimeSetterController.o:      Classes/ManualTimeSetterController.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

Model.o:      Classes/Model.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

OnOffCell.o:      Classes/OnOffCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

Section.o:      Classes/Section.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

SingletonDataSources.o:      Classes/SingletonDataSources.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

ManualTimeCell.o:      Classes/ManualTimeCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

MultipleTimeCell.o:      Classes/MultipleTimeCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

BaseController.o:      Classes/BaseController.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

ScheduleTimeCell.o:      Classes/ScheduleTimeCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

ScheduleTimeViewController.o:      Classes/ScheduleTimeViewController.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

StatusCell.o:      Classes/StatusCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

FixSilentSwitch.o:      Classes/FixSilentSwitch.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

UploadLogsCell.o:      Classes/UploadLogsCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

SendEmailCell.o:      Classes/SendEmailCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

BaseDictionary.o:      Classes/BaseDictionary.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

Schedule.o:      Classes/Schedule.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

CalenderSchedule.o: Classes/CalenderSchedule.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

Profile.o: Classes/Profile.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

NameCell.o: Classes/NameCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

ProfileListController.o: Classes/ProfileListController.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

SceduleRepeatStringCell.o: Classes/SceduleRepeatStringCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

RepeatListController.o: Classes/RepeatListController.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

TextFieldCell.o: Classes/TextFieldCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

ScheduleViewController.o: Classes/ScheduleViewController.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

ScheduleNameCell.o: Classes/ScheduleNameCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

ProfileViewController.o: Classes/ProfileViewController.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

ProfileAddController.o: Classes/ProfileAddController.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

ProfileNameCell.o: Classes/ProfileNameCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

TextFieldController.o: Classes/TextFieldController.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

FMDatabase.o : Classes/FMDatabase.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

FMDatabaseAdditions.o: Classes/FMDatabaseAdditions.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

FMResultSet.o: Classes/FMResultSet.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

Calendar.o: Classes/Calendar.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

TextViewCell.o: Classes/TextViewCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

ManualSchedule.o: Classes/ManualSchedule.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

ManualProfileCell.o: Classes/ManualProfileCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

CheckmarkCell.o: Classes/CheckmarkCell.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

%.o: Classes/%.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

package:
	cp -p SilentMe ./SilentMe.app
clean:
	rm -f *.o *.gch
	rm -f ./SilentMe.app/SilentMe
	rm SilentMe


install: 
	scp $(Target) root@$(IP):/Applications/SilentMe.app/

