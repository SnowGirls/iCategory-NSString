
#import <Foundation/Foundation.h>

#import <objc/runtime.h>
#import "objc-internal.h"

NS_ASSUME_NONNULL_BEGIN

@interface ObjcUtil : NSObject

// call the origin method in the method list
+ (void)invokeOriginalMethod:(id)target selector:(SEL)selector ;


// wrapped objc inline methods
+ (bool)objcIsTaggedPointer:(_Nonnull id)pointer;

+ (long)objcGetTaggedPointerValue:(_Nonnull id)pointer;

+ (char *)objcDecodeTaggedPointerString:(_Nonnull id)pointer;

@end

NS_ASSUME_NONNULL_END


// copy from objc-internal.h [https://opensource.apple.com/tarballs/objc4/]

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-objc-pointer-introspection"

static bool isTaggedPointer(_Nonnull id pointer) {
    return (long)(__bridge void *)pointer & (1UL<<63);
}

static bool objc_isTaggedPointer(_Nonnull id pointer)
{
    return _objc_isTaggedPointer((__bridge void *)pointer);
}

static uintptr_t objc_getTaggedPointerValue(_Nonnull id pointer) {
    return _objc_getTaggedPointerValue((__bridge void *)pointer);
}

static char* _Nonnull objc_decodeTaggedPointerString(_Nonnull id pointer) {
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
