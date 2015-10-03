#import <Security/Security.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFDate.h>

#import "SilentMed.h"

static const UInt8 publicKeyIdentifier[] = "com.apple.sample.publickey\0";
static const UInt8 privateKeyIdentifier[] = "com.apple.sample.privatekey\0";
#define PublicKeyPathString @"/Applications/SilentMe.app/publikey.cer"


void testcrypt(void)
{
	SecKeyRef oPublicKey;
	SecKeyRef oPrivateKey;	
	
	CFDictionaryRef myDictionary;
	
	CFTypeRef keys[2];
	CFTypeRef values[2];
	
	// Initialize dictionary of key params
	keys[0] = kSecAttrKeyType;
	values[0] = kSecAttrKeyTypeRSA;
	keys[1] = kSecAttrKeySizeInBits;
	int iByteSize = 1024;
	values[1] = CFNumberCreate( NULL, kCFNumberIntType, &iByteSize );
	myDictionary = CFDictionaryCreate( NULL, keys, values, sizeof(keys) / sizeof(keys[0]), NULL, NULL );
	
	// Generate keys
	OSStatus status = SecKeyGeneratePair( myDictionary, &oPublicKey, &oPrivateKey );
//	Log((CFStringRef)[NSString stringWithFormat:"crypt status %@", status]);
}


// 1

void generateKeyPairPlease()
{
    OSStatus status = noErr;
    NSMutableDictionary *privateKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *publicKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *keyPairAttr = [[NSMutableDictionary alloc] init];
	// 2
	
    NSData * publicTag = [NSData dataWithBytes:publicKeyIdentifier
										length:strlen((const char *)publicKeyIdentifier)];
    NSData * privateTag = [NSData dataWithBytes:privateKeyIdentifier
										 length:strlen((const char *)privateKeyIdentifier)];
	// 3
	
    SecKeyRef publicKey = NULL;
    SecKeyRef privateKey = NULL;                                // 4
	
    [keyPairAttr setObject:(id)kSecAttrKeyTypeRSA
					forKey:(id)kSecAttrKeyType]; // 5
    [keyPairAttr setObject:[NSNumber numberWithInt:1024]
					forKey:(id)kSecAttrKeySizeInBits]; // 6
	
    [privateKeyAttr setObject:[NSNumber numberWithBool:YES]
					   forKey:(id)kSecAttrIsPermanent]; // 7
    [privateKeyAttr setObject:privateTag
					   forKey:(id)kSecAttrApplicationTag]; // 8
	
    [publicKeyAttr setObject:[NSNumber numberWithBool:YES]
					  forKey:(id)kSecAttrIsPermanent]; // 9
    [publicKeyAttr setObject:publicTag
					  forKey:(id)kSecAttrApplicationTag]; // 10
	
    [keyPairAttr setObject:privateKeyAttr
					forKey:(id)kSecPrivateKeyAttrs]; // 11
    [keyPairAttr setObject:publicKeyAttr
					forKey:(id)kSecPublicKeyAttrs]; // 12
	
    status = SecKeyGeneratePair((CFDictionaryRef)keyPairAttr,
								&publicKey, &privateKey); // 13
	//    error handling...

	if(status == noErr)
	{
//		NSError* err;
		
//		[publicKey writeToFile:PublicKeyPathString options:NSAtomicWrite error:&err];
		[publicKey writeToFile:PublicKeyPathString atomically:YES];
	}
	
    if(privateKeyAttr) [privateKeyAttr release];
    if(publicKeyAttr) [publicKeyAttr release];
    if(keyPairAttr) [keyPairAttr release];
    if(publicKey) CFRelease(publicKey);
    if(privateKey) CFRelease(privateKey);                       // 14
}