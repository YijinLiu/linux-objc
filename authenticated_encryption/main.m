#import <Foundation/Foundation.h>

#include "aead.h"
#include "util.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString* aesKeyStr = [@"p" repeat:16];
    NSData* aesKey = [aesKeyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString* hmacKeyStr = [@"p" repeat:32];
    NSData* hmacKey = [hmacKeyStr dataUsingEncoding:NSUTF8StringEncoding];
    AEAD *aead = [[AEAD alloc] init:aesKey hmacSha256Key:hmacKey];
    NSString* plainTextStr = @"test";
    NSData* plainText = [plainTextStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString* nonceStr = [@"" stringByPaddingToLength:12 withString: @"n" startingAtIndex:0];
    NSData* nonce = [nonceStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* cipherText = [aead seal:plainText nonce:nonce additionalData:nil];
    //NSData* decrypted = [aead open:cipherText nonce:nonce additionalData:nil];
    //NSString* decryptedStr = [[[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"%@ => %@", plainTextStr, [cipherText toHexStr]);
    [aead release];
    [pool drain];
    return 0;
}
