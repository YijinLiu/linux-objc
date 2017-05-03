#import <Foundation/Foundation.h>


void testNSDataCouldBeDictionaryKey() {
    NSMutableDictionary<NSData *, NSString *> *dictionary = [[NSMutableDictionary alloc] init];
    NSData *key1 = [@"key1" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *key2 = [@"key2" dataUsingEncoding:NSUTF8StringEncoding];
    dictionary[key1] = @"str1";
    dictionary[key2] = @"str2";
    const char *cstr = "key1";
    NSData *key = [NSData dataWithBytes:cstr length:strlen(cstr)];
    NSLog(@"dictionary[\"%s\"]=%@", cstr, dictionary[key]);
}

void testParseHexString() {
    const char* cstr = "10:e6:fc:62:b7:41:8a:d5";
    NSString *str = [[NSString stringWithUTF8String:cstr] stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:str];
    unsigned long long value;
    if (![scanner scanHexLongLong:&value]) {
        NSLog(@"Failed to parse %s(%@)!", cstr, str);
    } else {
        NSLog(@"%s is %llx", cstr, value);
    }
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    testNSDataCouldBeDictionaryKey();
    testParseHexString();
    [pool drain];
    return 0;
}
