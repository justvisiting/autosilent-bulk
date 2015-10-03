//does not work 
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

//does not work

int callback(void *connection, CFStringRef string, CFDictionaryRef dictionary, void *data) {
	return 1;
}

int* __vibratorInit(void) {
	int x;
	printf("__vibrateInit()\n");
	return _CTServerConnectionCreate(kCFAllocatorDefault, callback, &x);
}

int __vibratorStart(int* conn) {
	int x = 0;
	return _CTServerConnectionSetVibratorState(&x, conn, 3, 20.0, 1.0, 1.0, 2.0);
}

int __vibratorStop(int* conn) {
	int x = 0;
	return _CTServerConnectionSetVibratorState(&x, conn, 0, 10, 10, 10, 10);
}

int __vibrator(int seconds) {
	printf("__vibrator()\n");
	int *conn = __vibratorInit();
	printf("__vibratorStart(%d)\n", conn);
	__vibratorStart(conn);
	printf("__vibratorStartdone(%d)\n", conn);
	time_t now = time(0);
	while(time(0) - now < seconds)
	{
	}
	printf("__vibratorStop\n");
	__vibratorStop(conn);
	return 1;
}
