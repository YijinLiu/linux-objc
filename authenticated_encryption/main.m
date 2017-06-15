#import <Foundation/Foundation.h>

#include "aead.h"

@interface NSData (Conversion)
- (NSString *)toHexStr;
@end

@implementation NSData (Conversion)
- (NSString *)toHexStr {
    const unsigned char *data = (const unsigned char *)[self bytes];
    if (!data) return [NSString string];
    NSUInteger          len  = [self length];
    NSMutableString     *hexStr  = [NSMutableString stringWithCapacity:(len * 2)];
    for (int i = 0; i < len; ++i)
        [hexStr appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)data[i]]];
    return [NSString stringWithString:hexStr];
}
@end


@interface NSString (Repeat)
- (NSString *)repeat:(NSUInteger)times;
@end

@implementation NSString (Repeat)
- (NSString *)repeat:(NSUInteger)times {
 	return [@"" stringByPaddingToLength:times * [self length] withString:self startingAtIndex:0];
}
@end

int main (int argc, const char * argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString* aesKeyStr = [@"p" repeat:16];
    NSData* aesKey = [aesKeyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString* hmacKeyStr = [@"p" repeat:32];
    NSData* hmacKey = [hmacKeyStr dataUsingEncoding:NSUTF8StringEncoding];
    AEADWithAESCtrAndHMACSHA256 *aead = [[AEADWithAESCtrAndHMACSHA256 alloc] initWithAESKey:aesKeyStr hmacKey:hmacKey];
    NSString* plainTextStr = @"test";
    NSData* plainText = [plainTextStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString* nonceStr = [@"" stringByPaddingToLength:12 withString: @"n" startingAtIndex:0];
    NSData* nonce = [nonceStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* cipherText = [aead seal:plainText nonce:nonce additionalData:nil];
    NSData* decrypted = [aead open:cipherText nonce:nonce additionalData:nil];
    NSString* decryptedStr = [[[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"%@ => %@ => %@", plainTextStr, [cipherText toHexStr], decryptedStr);
    [aead release];
    [pool drain];
    return 0;
}
