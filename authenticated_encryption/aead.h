#ifndef AEAD_H_
#define AEAD_H_

#import <Foundation/Foundation.h>

@interface AEAD : NSObject
{
    uint32_t aesKey[44];
    uint8_t hmacKey[32];
}

- (id) init:(NSData *)aes128Key hmacSha256Key:(NSData *)hmacSha256Key;

- (NSData *)seal:(NSData *)plainText nonce:(NSData *)nonce additionalData:(NSData *)additionalData;

//- (NSData *)open:(NSData *)cipherText nonce:(NSData *)nonce additionalData:(NSData *)additionalData;

@end

#endif
