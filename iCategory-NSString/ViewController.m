//
//  ViewController.m
//  iCategory-NSString
//
//  Created by xpeng on 2022/9/6.
//

#import "ViewController.h"

#import <mach-o/dyld.h>
#import <objc/runtime.h>

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "TaggedPointerModel.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // You can disable NSTaggedPointer by implement + (void)initialize method with a NSString+Category
    NSString *pointer = [NSString stringWithUTF8String:"123"];
    Class clazz = [pointer class];
    NSString *clazzName = [[NSString alloc] initWithFormat:@"%@", clazz];
    BOOL isEnableTaggedPointer = [clazzName containsString:@"TaggedPointer"];
    NSLog(@"Tagged Pointer String enable or not: %d, %@, %d", isEnableTaggedPointer, clazzName, isTaggedPointer(pointer));
    
    NSString *format = @"Tagged Pointer String enable status: %@";
    NSString *enableString = [NSString stringWithFormat:format, isEnableTaggedPointer ? @"TRUE" : @"FALSE"];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, 300, 250)];
    textView.scrollEnabled = TRUE;
    
    NSString *string = [self checkIfTaggedPointerEnable];
    [textView setText:[NSString stringWithFormat:@"%@\n%@", enableString, string]];
    [self.view addSubview:textView];
    
    // First, open Photos App, and add some album with a short album name input manually ~~~
    
    // Second, run this app and grant all photo permissions, the click the button below ~~~
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 200, 50)];
    [button setTitle:@"Click me" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickMe:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)clickMe:(UIButton *)button {
    PHFetchResult *userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    for (PHAssetCollection *collection in userAlbums) {
        // Access the collection.localizedTitle, he is a NSTaggedPointerString when album name is short
        NSString *string = collection.localizedTitle;
        
        // Send message to collection.localizedTitle, aka call objc_msgSend
        // Will crash when reach userAlbums. if you have a NSString category with + (void)initialize method override
        NSLog(@">>>>>>>>>>>> album name: %@", [string description]);
        
        // Uncomment the `[NSString invokeOriginalMethod:self selector:_cmd];` code in file NSString+Extension.m , then will not crash :P
        // Try yourself :)
    }
}

- (NSString *)checkIfTaggedPointerEnable {
    NSLog(@"\n\n----------------- NSTaggedPointerString CHECK -----------------");
    
    TaggedPointerModel* model = [[TaggedPointerModel alloc] init];
    NSLog(@"------->>>>> longTitle: %s, %@",(const char *)class_getName([model.longTitle class]),  model.longTitle);
    NSLog(@"------->>>>> shortTitle: %s, %@", (const char *)class_getName([model.shortTitle class]), model.shortTitle);
    
    NSString *result = @"";
    NSString *str = NULL;
    NSString *line = NULL;
    NSString *format = @"%@ : %p, %@";
    NSString *lineFormat = @"%@\n%@";
    
    str = @"1234567";
    line = [NSString stringWithFormat:format , str.class, str, str];
    result = [NSString stringWithFormat:lineFormat, result, line];
    NSLog(@"%@", line);
    
    str = [NSString stringWithUTF8String:"1234567"];       // length 7
    line = [NSString stringWithFormat:format , str.class, str, str];
    result = [NSString stringWithFormat:lineFormat, result, line];
    NSLog(@"%@", line);
    
    str = [NSString stringWithUTF8String:"abcdabcd"];      // length 8
    line = [NSString stringWithFormat:format , str.class, str, str];
    result = [NSString stringWithFormat:lineFormat, result, line];
    NSLog(@"%@", line);
    
    str = [NSString stringWithUTF8String:"eeeeeeeeeee"];   // length 11
    line = [NSString stringWithFormat:format , str.class, str, str];
    result = [NSString stringWithFormat:lineFormat, result, line];
    NSLog(@"%@", line);
    
    str = [NSString stringWithUTF8String:"eeeeeeeeeeee"];  // length 12
    line = [NSString stringWithFormat:format , str.class, str, str];
    result = [NSString stringWithFormat:lineFormat, result, line];
    NSLog(@"%@", line);
    
    NSLog(@"\n\n----------------- NSTaggedPointerString END -----------------");
    NSLog(@"\n\n");
    return result;
}


@end



