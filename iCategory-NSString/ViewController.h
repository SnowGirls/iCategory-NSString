//
//  ViewController.h
//  iCategory-NSString
//
//  Created by xpeng on 2022/9/6.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-objc-pointer-introspection"

BOOL isTaggedPointer(id pointer) {
    return (long)(__bridge void *)pointer & 1;
}

#pragma clang diagnostic pop

