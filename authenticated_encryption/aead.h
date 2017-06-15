#ifndef AEAD_H_
#define AEAD_H_

#import <Foundation/Foundation.h>

@interface AEAD : NSObject
{
    uint32_t aesKey[44];
}

- (id) initWithAESKey:(NSData *)aes128Key hmacKey:(NSData *)hmacSha256Key

- (NSData *)seal:(NSData *)plainText nonce:(NSData *)nonce additionalData:(NSData *)additionalData

- (NSData *)open:(NSData *)cipherText nonce:(NSData *)nonce additionalData:(NSData *)additionalData

@end

#endif
