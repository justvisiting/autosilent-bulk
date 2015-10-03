#define ManualOrAutomaticSelectedKey @"isManual"
#define DateUntilManualModeIsApplicableKey @"DateUntilManualModeIsApplicable"

#define NotificaitonRunDaemon @"com.iphonepackers.runsilentMed"
#define NotificaitonringerToggleStatusOn @"com.iphonepackers.ringerToggleStatusOn"
#define NotificaitonringerToggleStatusOff @"com.iphonepackers.ringerToggleStatusOff"
#define NotificaitonSilentSwitchChanged @"com.apple.springboard.ringerstate"
#define NotificaitonByPassSilentSwitchOff @"com.iphonepackers.ByPassSilentSwitchOff"
#define NotificaitonByPassSilentSwitchOn @"com.iphonepackers.ByPassSilentSwitchOn"
#define NotificaitonManualModeSwitchedByUIOn @"com.iphonepackers.ManualSwitchedOn"
#define NotificaitonManualModeSwitchedByUIOff @"com.iphonepackers.ManualSwitchedOff"
#define NotificaitonManualModeProfileChanged @"com.iphonepackers.ManualProfileChanged"
#define NotificaitonActiveScheduleChanged @"com.iphonepackers.ActiveScheduleChanged"
static CFStringRef const NotificaitonSilentOn = CFSTR("com.iphonepackers.silentMeOn");
static CFStringRef const NotificaitonSilentOff = CFSTR("com.iphonepackers.silentMeOff");

#define NotificaitonProfileChanged @"com.iphonepackers.profilechanged"
#define NotificaitonScheduleChanged @"com.iphonepackers.schedulechanged"

//#define NotificaitonByPassSilentSwitchOffFixed @"com.iphonepackers.ByPassSilentSwitchOffFixed"
//#define NotificaitonByPassSilentSwitchOnFixed @"com.iphonepackers.ByPassSilentSwitchOnFixed"

//settings plist key names
#define AppEnabledKey  @"AppEnabled"
#define ProfilesKeyName  @"Profiles"
#define CalendarSyncEnabledKey @"CalSyncEnabled"
#define ManualModeProfileKey @"ManualModeProfile"
static NSString * const CalendarProfileTag = @"CalendarProfile";

static NSString * const calendersettingsPath = @"/User/Library/Preferences/com.apple.accountsettings.plist";
static NSString * const calendersettingsDir = @"/User/Library/Preferences";
static NSString * const calendersettingsFileName = @"com.apple.accountsettings.plist";
static NSString * const calendarFilePath = @"/Applications/SilentMe.app/configs/calendars.plist";
static NSString * const settingsPath = @"/Applications/SilentMe.app/settings.plist";
static NSString * const daemonPath = @"/Applications/SilentMe.app/daemonsettings.plist";
static NSString * const appPath = @"/Applications/SilentMe.app";
static NSString * const OnIcon = @"/Applications/SilentMe.app/SilentOn.png";
static NSString * const OffIcon = @"/Applications/SilentMe.app/SilentOff.png";
static NSString * const SettingsDisabledIcon = @"/Applications/SilentMe.app/SilentDisabled.png";
static NSString * const  ScheduleFilePath = @"/Applications/SilentMe.app/configs/schedule.plist";
static NSString * const  ProfilesFilePath = @"/Applications/SilentMe.app/configs/profiles.plist";
static NSString * const configsPath = @"/Applications/SilentMe.app/configs";
static NSString * const SpringBoardPlistPath =  @"/private/var/mobile/Library/Preferences";
static NSString * const SpringBoardPlistFileName = @"com.apple.springboard.plist";

static NSString * const NotificaitonRingerOn = @"com.iphonepackers.ringerOn";
static NSString * const NotificaitonRingerOff = @"com.iphonepackers.ringerOff";
static NSString * const NotificaitonRunSilentMed = NotificaitonRunDaemon;
static NSString * const NotificaitonVibrateOn = @"com.iphonepackers.vibrateOn";
static NSString * const NotificaitonVibrateOff = @"com.iphonepackers.vibrateOff";
static NSString * const NotificationSilentStatusChanged = @"com.iphonepackers.statusChanged";
static NSString * const NotificationFixSilentSwitch = NotificaitonByPassSilentSwitchOn;
static NSString * const NotificationUnFixSilentSwitch = NotificaitonByPassSilentSwitchOff;
static NSString * const NotificationFixSilentSwitchDone =  @"com.iphonepackers.ByPassSilentSwitchFixDone"; //confirm useless
//static NSString * const NotificationFixSilentSwitch = @"com.iphonepackers.fixsilentswitch";

static NSString * const NotificationDisableStatusIcon =  @"com.iphonepackers.DisableStatusIcon"; 
static NSString * const NotificationEnableStatusIcon =  @"com.iphonepackers.EnableStatusIcon"; 
static NSString * const DisableStatusIconKey = @"DisableStatusIcon";

//In App notifications
static NSString * const StatusChangedNotification = @"appstatuschanged";
static NSString * const CustomVolumeChangedNotification = @"customvolumechanged";
static NSString * const AutomaticValueChangedNotification = @"automaticvaluechanged";

//static NSString * const logPath = @"/Applications/SilentMe.app";
static NSString * const logPath = @"/private/var/mobile/Library/SilentMe";

static NSString * const AutomaticEnabledKey =  @"AutomaticEnabled";
//static NSString * const AppEnabled = AppEnabledKey;
static NSString * const PhoneEnabled = @"CallEnabled";
static NSString * const VibrateEnabled = @"VibrateEnabled";
static NSString * const VoiceMailEnabled = @"VoiceMailenabled";
static NSString * const NewMailEnabled = @"NewMailEnabled";
static NSString * const SentMailEnabled = @"SentMailEnabled";
static NSString * const CalAlertEnabled = @"CalAlertEnabled";
static NSString * const SmsAlertEnabled = @"SmsAlertEnabled";
static NSString * const VolumeLevel = @"VolumeLevel";
static NSString * const CustomVolumeEnabled = @"CustomVolume";

static NSString * const CalSyncEnabled = @"CalSyncEnabled";
static NSString * const OrigRingTone = @"OrigRingTone";
static NSString * const LockUnlockEnabled = @"LockUnLockSoundEnabled";
static NSString * const KeyboardSoundEnabled = @"KeyboardSoundEnabled";
static NSString * const PushNotificationEnabled = @"PushNotificationEnabled";

static NSString* const CurrentProfileKey = @"CurrentProfile";
static NSString* const CurrentScheduleKey = @"CurrentSchedule";

static NSString * const LoggingEnabled = @"LoggingEnabled";
static NSString * const SilentModeOn = @"silentModeOn";
//static NSString * const SilentSwitchFixDone = @"SilentSwitchFixDone";
static NSString * const SilentSwitchFixDone = @"ByPassSilentSwitchStatus";

static NSString * const ActivationTag = @"key";
static NSString * const IsKeyNotValid = @"IsKeyNotValid";

static NSString * const NoAutoSilentCalendarStringKey = @"NoAutoSilentCalendarString";

static NSString * const ManualEndTime = DateUntilManualModeIsApplicableKey;
static NSString * const ManualMode = ManualOrAutomaticSelectedKey;

static NSString * const ManualId = @"ManualId";

static NSString * const URLString = @"http://iphonepackers.info/app/VerifyApp?v=4&locale=%@&code=%@";
//static NSString * const BuyURLString = @"http://www.iphonepackers.info/app/BuyAutoSilent?v=3&deviceid=";
static NSString * const BuyURLString = @"http://www.iphonepackers.info/app/Buy?v=4&appid=autosilent&locale=%@&code=%@";

static NSString * const LogUrl = @"http://iphonepackers.info/app/LogDiagnostics?v=4&appId=autosilent&code=";
static NSString * const ReferStatisticsURL = @"http://iphonepackers.info/app/ReferStats?v=4&appId=autosilent&code=";

static NSString * const NotActivatedStr = @"The app is not yet activated, please press OK to activate the app";

static NSString * const Pending = @"pending";
static NSString * const Failed = @"failed";
static NSString * const Reversed = @"reversed";
static NSString * const NotActivated = @"notactivated";

static NSString * const Completed = @"completed";
static NSString * const Error = @"error";
static NSString * const OurError = @"ourerror";


static NSString * const SuccessMsg = @"The app has been successfully activated. Enjoy your Silent hours!";
static NSString * const PendingMsg = @"Sorry your payment is still being processed. You will be asked to activate again. Enjoy all the benefits of AutoSilent till then.";
static NSString * const NotPurchasedMsg = @"To enjoy Silent Hours, please purchase the product from cydia store. The app will run for a trial period of 3 days.";
static NSString * const GenericActivationError = @" Sorry we cannot activate the product now, you will be asked to reactivate later. If problem continues, contact autosilent@iphonepackers.info";
static NSString * const PaymentServiceError = @" There was a problem connecting to the payment service.You will be asked to activate later.";
static NSString * const PaymentFailed = @" Your payment was not completed successfully. Please purchase the program again or try later.";

//Visual labels

static NSString * const RingToneLabel = @"RingTone";

static NSString * const VibrateLabel=@"Vibrate Alert";

static NSString * const  VoiceMailLabel= @"VoiceMail Alert";

static NSString * const NewMailLabel = @"New Mail";

static NSString * const CalenderLabel = @"Calender Alerts";

static NSString * const NewTextLabel = @"New Text Message";

static NSString * const  LockSoundsLabel = @"Lock Sounds";

static NSString * const KeyboardSoundLabel = @"Keyboard Clicks";

static NSString * const PushNotificationLabel = @"Push Notifications";

static NSString * const SentMailLabel = @"Sent Mail";

static NSString * const DefaultProfileName = @"None";

static const int CalenderScheduleId = -1;
static const int ManualScheduleId = -2;
static const int SilentProfileId = 1;
static const int DefaultProfileId = 0;
static const int DefaultScheduleIdWhenNoScheduleIsApplicable = 0;
