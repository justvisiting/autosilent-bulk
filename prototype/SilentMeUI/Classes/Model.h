#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseDictionary.h"

@interface Model  : BaseDictionary
{
@public
	//MYSwitch        *appEnabled;
	//MYSwitch		*weekdayNightsEnabled;
	//MYSwitch        *weekendNightsEnabled;
	//MYSwitch		*calenderSyncEnabled;
    
	//TimeButton  *weekdayNightStart;
	//TimeButton  *weekdayNightEnd;
	//TimeButton  *weekendNightStart;
	//TimeButton  *weekendNightEnd;
	
	//PropertiesView Elements
	//MYSwitch           *callEnabled;
	//MYSwitch           *vibrateEnabled;
	//MYSwitch			*voiceMailEnabled;
	//MYSwitch           *newMailEnabled;
	//MYSwitch           *calenderAlertEnabled;
	//MYSwitch           *smsAlertEnabled;
	//MYSwitch           *lockUnlockEnabled;
	//MYSwitch			*keyboardSoundEnabled;
	
	//Debug Elements
	//MYSwitch  * loggingSwitch;
	
	//Status Button
	//UIButton * statusButton;
	
	int   weekendNightStartTime;
	int   weekendNightEndTime;
	
	int   weekdayNightStartTime;
	int   weekdayNightEndTime;
	
	
	NSString * deviceActivated;
	
	NSDictionary * daemonDict;
	BOOL silentModeOn;
	//CFURLRef fileURL;
	
}

+ (Model*) GetModel;

- (void) refreshStatusButton;

//-(void) InitObserver;

-(BOOL) GetBoolValue:(NSString*) key;

-(BOOL) GetBoolValueFromDaemon:(NSString*) key;

-(void) SetBoolValue:(NSString*)key value:(BOOL)val;

-(int) GetIntegerValue:(NSString*)key;

-(id) GetValueFromDaemon:(NSString*) key;

-(void) SetIntegerValue:(NSString*)key value:(int)val;

-(void) SetDateValue:(NSString*)key value:(NSDate *)val;

- (CFPropertyListRef) CreateListFromFile:(CFStringRef) filePath;

-(void) initialize;

-(void) WriteToDictionary;

- (void) WriteValues;

- (void) RefreshDaemonDictionary;

-(void) InitInterProcessObserver;

-(void) SynchronizeManualSettings;

-(void) SetBoolValueWithoutNotification:(NSString*)key value:(BOOL)val;
@end