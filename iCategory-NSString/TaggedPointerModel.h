//
//  TaggedPointerModel.h
//  iCategory-NSString
//
//  Created by xpeng on 2022/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaggedPointerModel : NSObject

@property (nonatomic, strong, readonly, nullable) NSString *shortTitle;

@property (nonatomic, strong, readonly, nullable) NSString *longTitle;

@end

NS_ASSUME_NONNULL_END
