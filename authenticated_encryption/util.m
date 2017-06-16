#include "util.h"

@implementation NSData (Conversion)
- (NSString *)toHexStr {
    const unsigned char *data = (const unsigned char *)[self bytes];
    if (!data) return [NSString string];
    NSUInteger          len  = [self length];
    NSMutableString     *hexStr  = [NSMutableString stringWithCapacity:(len * 2)];
    for (int i = 0; i < len; ++i) {
        if (i > 0) [hexStr appendString:@":"];
        [hexStr appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)data[i]]];
    }
    return [NSString stringWithString:hexStr];
}
@end


@implementation NSString (Repeat)
- (NSString *)repeat:(NSUInteger)times {
 	return [@"" stringByPaddingToLength:times * [self length] withString:self startingAtIndex:0];
}
@end
