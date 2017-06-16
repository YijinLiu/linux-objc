#ifndef AES_H
#define AES_H

#include <inttypes.h>

#define AES_BLOCK_SIZE 16               // AES operates on 16 bytes at a time

void aes_key_setup(const uint8_t key[],          // The key, must be 128, 192, or 256 bits
                   uint32_t w[],                  // Output key schedule to be used later
                   int keysize);              // Bit length of the key, 128, 192, or 256

void aes_encrypt(const uint8_t in[],             // 16 bytes of plaintext
                 uint8_t out[],                  // 16 bytes of ciphertext
                 const uint32_t key[],            // From the key setup
                 int keysize);                // Bit length of the key, 128, 192, or 256

void aes_decrypt(const uint8_t in[],             // 16 bytes of ciphertext
                 uint8_t out[],                  // 16 bytes of plaintext
                 const uint32_t key[],            // From the key setup
                 int keysize);                // Bit length of the key, 128, 192, or 256

#endif   // AES_H
