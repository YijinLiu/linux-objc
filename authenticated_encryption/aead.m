#include "aead.h"

#include "aes.h"
#include "sha256.h"

@implementation AEAD

- (id) init:(NSData *)aes128Key hmacSha256Key:(NSData *)hmacSha256Key
{
    self = [super init];
    // TODO: Check aes128Key is 16 bytes.
    aes_key_setup((uint8_t*)[aes128Key bytes], aesKey, 128);
    // TODO: Check hmacKey is 32 bytes.
    [hmacSha256Key getBytes:hmacKey length:32];
    return self;
}

- (NSData *)seal:(NSData *)plainText nonce:(NSData *)nonce additionalData:(NSData *)additionalData
{
    // Init AES counter.
    // TODO: Check nounce is 12 bytes.
    uint8_t counter[16];
    [nonce getBytes:counter length:12];
    counter[12] = counter[13] = counter[14] = counter[15] = 0;

    // Encrypt plainText using AES CTR mode.
    int len = [plainText length];
    NSMutableData *cipherText = [NSMutableData dataWithCapacity:len+32];
    [cipherText appendData:plainText];
    uint8_t* encryptedBytes = [cipherText mutableBytes];
    for (int i = 0; i < len; i+=16) {
        uint8_t encryptedCounter[16];
        aes_encrypt(counter, encryptedCounter, aesKey, 128);
        for (int k = 0; k < 16; k++) {
            const int s = i + k;
            if (s >= len) break;
            encryptedBytes[s] ^= encryptedCounter[k];
        }
        // Increase counter.
        for (int j = 15; j >= 12; j--) if (++counter[j] != 0) break;
    }

    // Construct message for HMAC.
    int adLen = 0;
    if (additionalData != nil) adLen = [additionalData length];
    int msgLen = 8 // length of additionalData
        + 8  // length of cipherText
        + 12  // nonce
        + adLen;
    // Pad to 64.
    int pad = (msgLen + 63) / 64 * 64 - msgLen;
    msgLen += pad + len;
    NSMutableData* msg = [NSMutableData dataWithCapacity:msgLen];
    // Append adLen as little endian 64 bit integer.
    uint64_t u64Data = adLen;
    uint8_t bytes[8];
    for (int i = 0; i < 8; i++) {
        bytes[i] = u64Data & 0xff;
        u64Data >>= 8;
    }
    [msg appendBytes:bytes length:8];
    // Append len as little endian 64 bit integer.
    u64Data = len;
    for (int i = 0; i < 8; i++) {
        bytes[i] = u64Data & 0xff;
        u64Data >>= 8;
    }
    [msg appendBytes:bytes length:8];
    // Append nounce.
    [msg appendData:nonce];
    // Append additionalData.
    if (additionalData != nil) [msg appendData:additionalData];
    // Pad.
    [msg increaseLengthBy:pad];
    // Append cipherText.
    [msg appendData:cipherText];
    const uint8_t* msgBytes = [msg bytes];

    // HMAC.
    SHA256_CTX ctx;
    sha256_init(&ctx);
    uint8_t tmpKey[64];
    for (int i = 0; i < 32; i++) tmpKey[i] = hmacKey[i] ^ 0x36;
    for (int i = 32; i < 64; i++) tmpKey[i] = 0x36;
    sha256_update(&ctx, tmpKey, 64);
    sha256_update(&ctx, msgBytes, msgLen);
    uint8_t hash[32];
    sha256_final(&ctx, hash);
    sha256_init(&ctx);
    for (int i = 0; i < 32; i++) tmpKey[i] = hmacKey[i] ^ 0x5c;
    for (int i = 32; i < 64; i++) tmpKey[i] = 0x5c;
    sha256_update(&ctx, tmpKey, 64);
    sha256_update(&ctx, hash, 32);
    sha256_final(&ctx, hash);

    [cipherText appendBytes:hash length:32];
    return cipherText;
}

@end
