//
//  TaggedPointerModel.m
//  iCategory-NSString
//
//  Created by xpeng on 2022/9/7.
//

#import "TaggedPointerModel.h"

@implementation TaggedPointerModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _shortTitle = [NSString stringWithUTF8String:"you"];
        _longTitle = @"You know you will be rich in the future!";
    }
    return self;
}

@end
