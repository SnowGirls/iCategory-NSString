#import <UIKit/UIKit.h>

#import "objc-internal.h"


@interface ViewController : UIViewController


@end

// copy from objc-internal.h [https://opensource.apple.com/tarballs/objc4/]

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-objc-pointer-introspection"

static bool isTaggedPointer(_Nonnull id pointer) {
    return (long)(__bridge void *)pointer & (1UL<<63);
}

static char* decodeStringTaggedPointerToString(_Nonnull id pointer) {
    unsigned long value = _objc_getTaggedPointerValue((__bridge void *)pointer);
    int len = value & 0x7;
    value = value >> 4;
    
    char *result = malloc(sizeof(char) * len);
    NSLog(@"@@@@@ decoding characters length: %d", len);
    for (int i = 0; i < len; i++) {
        int ascii = value & 0xff;
        result[i] = (char)ascii;
        NSLog(@"@@@@@ decoding characters ascii: %c", ascii);
        value = value >> 8;
    }
    return result;
}

#pragma clang diagnostic pop


