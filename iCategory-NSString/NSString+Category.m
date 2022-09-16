#import "NSString+Category.h"

#import "ObjcUtil.h"

#include <stdlib.h>

@implementation NSString (Category)

+ (void)initialize
{
    // Solution 1: Call original initialize method
//    [ObjcUtil invokeOriginalMethod:self selector:_cmd];      // uncomment me ~~~, or change +initialize method to +load method
    
    
    // Solution 2: Enable NSTaggedPointerString using runtime api :P
//    Class clazzTagged = NSClassFromString(@"NSTaggedPointerString");
//    class_setSuperclass(clazzTagged, NSString.class);
//    [clazzTagged performSelector:NSSelectorFromString(@"_setAsTaggedStringClass")];
}

@end
