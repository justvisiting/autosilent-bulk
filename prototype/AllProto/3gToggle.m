//does not work
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#include <dlfcn.h>
#include <stdio.h>
#import <unistd.h>
#include <dlfcn.h>
#import "3gToggle.h"

void kCTRegistrationRATSelection0();
void kCTRegistrationRATSelection1();
void kCTRegistrationRATSelection2();

int callback(void *connection, CFStringRef string, CFDictionaryRef dictionary, void *data) {
	return 1;
}

int* ConnInit(void) {
	int x;
	printf("connInit()\n");
	return _CTServerConnectionCreate(kCFAllocatorDefault, callback, &x);
}



void Toggle3g()
{
	int x;
	int* conn = ConnInit();
	
	if(conn != NULL)
	{
		NSLog(@"got connection obj");
	}
	else
	{
		NSLog(@"conn obj is null");
	}
	
	CFMachPortCreateWithPort(kCFAllocatorDefault, _CTServerConnectionGetPort(conn), NULL, NULL, NULL);
	
	int status = _CTServerConnectionGetRATSelection(&conn);
	
	NSLog(@"got status %d", status);
	NSLog(@"print 01 %d", kCTRegistrationRATSelection2);
	
	_CTServerConnectionSetRATSelection(&conn, kCTRegistrationRATSelection0, &x);
}