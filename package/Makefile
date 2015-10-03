IP = 192.168.1.101
CONFIGPATH = ../configs/
ICONPATH = ../icons/SilentMeUI/
LPROJPATH = ../prototype/SilentMeUI/

ASToggle: copyASControl copyASThemes copyASToggle

copyASControl:
	cp ../sbSettingsTogglePackage/ASToggle/DEBIAN/control ASToggle/DEBIAN/
	cp ../sbSettingsTogglePackage/ASToggle/DEBIAN/postinst ASToggle/DEBIAN/

copyASThemes:
	cp ../sbSettingsTogglePackage/ASToggle/private/var/mobile/Library/SBSettings/Themes/Default/AS/on.png ASToggle/private/var/mobile/Library/SBSettings/Themes/Default/AS/
	cp ../sbSettingsTogglePackage/ASToggle/private/var/mobile/Library/SBSettings/Themes/Default/AS/off.png ASToggle/private/var/mobile/Library/SBSettings/Themes/Default/AS/

copyASToggle:
	cp ../sbSettingsTogglePackage/ASToggle/private/var/mobile/Library/SBSettings/Toggles/AS/Toggle.dylib ASToggle/private/var/mobile/Library/SBSettings/Toggles/AS/

AutoSilent: copySoundsPlist copyImages copyConfigs copyLocaleProj copyDebFiles \
	copyMobSubstrate copyExe

copySoundsPlist:
	cp $(CONFIGPATH)SystemSoundBehaviour.fixbrokenSilentSwitch.plist AutoSilent/Applications/SilentMe.app/configs/.SystemSoundBehaviour.plist
copyImages:
	cp $(ICONPATH)ScheduleOn.png AutoSilent/Applications/SilentMe.app/
	cp $(ICONPATH)ScheduleOff.png AutoSilent/Applications/SilentMe.app/
	cp $(ICONPATH)icon.png AutoSilent/Applications/SilentMe.app/

copyConfigs:
	cp ../package/AutoSilent/Applications/SilentMe.app/Info.plist AutoSilent/Applications/SilentMe.app/
	cp $(CONFIGPATH)settings.plist AutoSilent/Applications/SilentMe.app/
	cp $(CONFIGPATH)daemonsettings.plist AutoSilent/Applications/SilentMe.app/
	cp $(CONFIGPATH)profiles.plist AutoSilent/Applications/SilentMe.app/configs/
	cp $(CONFIGPATH)schedule.plist AutoSilent/Applications/SilentMe.app/configs/ 
	
copyLocaleProj:
	cp $(LPROJPATH)en.lproj/Localizable.strings AutoSilent/Applications/SilentMe.app/en.lproj/
	cp $(LPROJPATH)es.lproj/Localizable.strings AutoSilent/Applications/SilentMe.app/es.lproj/


copyMobSubstrate:
	scp root@$(IP):/Library/MobileSubstrate/DynamicLibraries/AutoSilent.dylib AutoSilent/Library/MobileSubstrate/DynamicLibraries/
copyExe:
	scp root@$(IP):/Applications/SilentMe.app/SilentMe AutoSilent/Applications/SilentMe.app/
	scp root@$(IP):/Applications/SilentMe.app/SilentMed AutoSilent/Applications/SilentMe.app/
	scp root@$(IP):/Applications/SilentMe.app/ConvertUtil AutoSilent/Applications/SilentMe.app/
#	cp ../AutoSilent/Applications/SilentMe.app/SilentMe AutoSilent/Applications/SilentMe.app/
#	cp ../AutoSilent/Applications/SilentMe.app/SilentMed AutoSilent/Applications/SilentMe.app/
#	cp ../AutoSilent/Applications/SilentMe.app/ConvertUtil AutoSilent/Applications/SilentMe.app/

copyDebFiles:
	cp ../package/AutoSilent/DEBIAN/control AutoSilent/DEBIAN/
	cp ../package/AutoSilent/DEBIAN/postinst AutoSilent/DEBIAN/
	cp ../package/AutoSilent/DEBIAN/preinst AutoSilent/DEBIAN/
	cp ../package/AutoSilent/DEBIAN/prerm AutoSilent/DEBIAN/
