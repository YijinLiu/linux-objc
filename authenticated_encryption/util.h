#ifndef UTIL_H_
#define UTIL_H_

#import <Foundation/Foundation.h>

@interface NSData (Conversion)
- (NSString *)toHexStr;
@end

@interface NSString (Repeat)
- (NSString *)repeat:(NSUInteger)times;
@end

#endif
