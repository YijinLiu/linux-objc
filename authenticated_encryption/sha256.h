#ifndef SHA256_H
#define SHA256_H

#include <stddef.h>

#define SHA256_BLOCK_SIZE 32            // SHA256 outputs a 32 byte digest

typedef uint8_t BYTE;             // 8-bit byte
typedef uint32_t WORD;             // 32-bit word, change to "long" for 16-bit machines

typedef struct {
	BYTE data[64];
	WORD datalen;
	unsigned long long bitlen;
	WORD state[8];
} SHA256_CTX;

void sha256_init(SHA256_CTX *ctx);
void sha256_update(SHA256_CTX *ctx, const BYTE data[], size_t len);
void sha256_final(SHA256_CTX *ctx, BYTE hash[]);

void hmac_sha256(const BYTE key[], const BYTE data[], size_t len, BYTE hash[]);

#endif   // SHA256_H
