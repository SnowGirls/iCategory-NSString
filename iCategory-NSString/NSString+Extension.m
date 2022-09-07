//
//  NSString+Extension.m
//  iCategory-NSString
//
//  Created by xpeng on 2022/9/6.
//

#import "NSString+Extension.h"
#import <objc/runtime.h>

@implementation NSString (Extension)

+ (void)initialize
{
    // Call original initialize method
    // [NSString invokeOriginalMethod:self selector:_cmd];      // uncomment me ~~~, or change +initialize method to +load method
}


// call the origin method in the method list
+ (void)invokeOriginalMethod:(id)target selector:(SEL)selector {
    Class clazz = [target class];
    Class metaClazz = objc_getMetaClass(class_getName(clazz));
    NSLog(@"Category ---> class: %@, metaClass: %@", clazz, metaClazz);
    
    // Get the instance method list in class
    uint instCount;
    Method *instMethodList = class_copyMethodList(clazz, &instCount);
    // Print to console
    for (int i = 0; i < instCount; i++) {
        Method method = instMethodList[i];
        NSLog(@"Category instance selector : %d %@", i, NSStringFromSelector(method_getName(method)));
    }
    
    // Get the class method list in meta class
    uint metaCount;
    Method *metaMethodList = class_copyMethodList(metaClazz, &metaCount);
    // Print to console
    for (int i = 0; i < metaCount; i++) {
        Method method = metaMethodList[i];
        NSLog(@"Category class selector : %d %@", i, NSStringFromSelector(method_getName(method)));
    }
    
    NSLog(@"Category ---> instance method count: %d, class method count: %d", instCount, metaCount);
    
    // Call original instance method. Note here take the last same name method as the original method
    for ( int i = instCount - 1 ; i >= 0; i--) {
        Method method = instMethodList[i];
        SEL name = method_getName(method);
        IMP implementation = method_getImplementation(method);
        if (name == selector) {
            NSLog(@"Category instance method found & call original ~~~");
            // id (*IMP)(id, SEL, ...)
            ((void (*)(id, SEL))implementation)(target, name);
            break;
        }
    }
    free(instMethodList);
    
    // Call original class method. Note here take the last same name method as the original method
    for ( int i = metaCount - 1 ; i >= 0; i--) {
        Method method = metaMethodList[i];
        SEL name = method_getName(method);
        IMP implementation = method_getImplementation(method);
        if (name == selector) {
            NSLog(@"Category class method found & call original ~~~");
            // id (*IMP)(id, SEL, ...)
            ((void (*)(id, SEL))implementation)(target, name);
            break;
        }
    }
    free(metaMethodList);
}

@end
