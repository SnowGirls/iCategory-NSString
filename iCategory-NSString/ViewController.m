#import "ViewController.h"

#import "ObjcUtil.h"

#import <mach-o/dyld.h>
#import <malloc/malloc.h>

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // You can disable NSTaggedPointer by implement + (void)initialize method with a NSString+Category
    
    BOOL isTaggedPointerStringEnable = [[[NSString alloc] initWithFormat:@"%@", [[NSString stringWithUTF8String:"123"] class]] containsString:@"TaggedPointer"];
    
    NSString *format = @"Tagged Pointer String enable status: %@";
    NSString *enableString = [NSString stringWithFormat:format, isTaggedPointerStringEnable ? @"TRUE" : @"FALSE"];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, 450, 250)];
    textView.scrollEnabled = TRUE;
    
    NSString *string = [self checkIfTaggedPointerEnable];
    [textView setText:[NSString stringWithFormat:@"%@\n%@", enableString, string]];
    [self.view addSubview:textView];
    
    // First, open Photos App, and add some album with a short album name input manually ~~~
    
    // Second, run this app and grant all photo permissions, the click the button below ~~~
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 250, 200, 50)];
    [button setTitle:@"Click me" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickMe:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *checkitoutButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 350, 200, 50)];
    [checkitoutButton setTitle:@"Check it out" forState:UIControlStateNormal];
    [checkitoutButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [checkitoutButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    [checkitoutButton addTarget:self action:@selector(checkItOut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkitoutButton];
}

- (void)clickMe:(UIButton *)button {
    PHFetchResult *userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    for (PHAssetCollection *collection in userAlbums) {
        // Access the collection.localizedTitle, it is a NSTaggedPointerString when your album name is short
        NSString *string = collection.localizedTitle;
        
        // Send message to collection.localizedTitle, aka call objc_msgSend
        // Will crash when reach userAlbums. if you have a NSString category with + (void)initialize method override
        NSLog(@">>>>>>>>>>>> album name: %@", [string description]);
        
        // Uncomment the `[ObjcUtil invokeOriginalMethod:self selector:_cmd];` code in file NSString+Category.m
        // Then will not crash :P, Try it yourself :)
    }
}

- (void)checkItOut:(UIButton *)button {
    NSLog(@"\n\n");
    NSLog(@"_objc_taggedPointersEnabled: %d", _objc_taggedPointersEnabled());
    
    // You can disable NSTaggedPointer by implement + (void)initialize method with a NSString+Category
    NSString *pointer = [NSString stringWithUTF8String:"ABCDE"];
    NSLog(@"_objc_isTaggedPointer: %d", _objc_isTaggedPointer((__bridge const void *)pointer));
    
    Class clazz = [pointer class];
    NSString *clazzName = [[NSString alloc] initWithFormat:@"%@", clazz];
    NSLog(@"%@ Class name is: %@", pointer, clazzName);
    
    BOOL isTaggedPointerStringEnable = [clazzName containsString:@"TaggedPointer"];
    NSLog(@"NSTaggedPointerString if enable: %d, is tagged pointer: %d", isTaggedPointerStringEnable, isTaggedPointer(pointer));
    NSLog(@"%@ malloc size is : %zu", pointer, malloc_size(CFBridgingRetain(pointer)));
    
    NSString *longString = [NSString stringWithUTF8String:"0123456789abcdef"];
    NSLog(@"%@ malloc size is : %zu", longString, malloc_size(CFBridgingRetain(longString)));
    
    if (!_objc_isTaggedPointer((__bridge const void *)pointer)){
        return;
    }
    NSLog(@"[tagged pointer class]: %@", _objc_getClassForTag(_objc_getTaggedPointerTag((__bridge void *)pointer)));
    NSLog(@"[tagged pointer value]: %lx", _objc_getTaggedPointerValue((__bridge void *)pointer));
    unsigned long value = _objc_getTaggedPointerValue((__bridge void *)pointer);
    int len = value & 0x7;
    value = value >> 4;
    NSLog(@"@@@@@@@@@ characters length: %d", len);
    for (int i = 0; i < len; i++) {
        int ascii = value & 0xff;
        NSLog(@"@@@@@@@@@ characters ascii: %c", ascii);
        value = value >> 8;
    }
    
    
    NSString *str = [NSString stringWithFormat:@"a"];
    NSLog(@"[tagged pointer class] str class: %@", _objc_getClassForTag(_objc_getTaggedPointerTag((__bridge void *)str)));
    NSLog(@"[tagged pointer value] str value: %lx", _objc_getTaggedPointerValue((__bridge void *)str));
    
    NSNumber *num = [NSNumber numberWithInteger:1];
    NSLog(@"[tagged pointer class] num class: %@", _objc_getClassForTag(_objc_getTaggedPointerTag((__bridge void *)num)));
    NSLog(@"[tagged pointer value] num value: %lx", _objc_getTaggedPointerValue((__bridge void *)num));

}

- (NSString *)checkIfTaggedPointerEnable {
    NSLog(@"\n\n----------------- NSTaggedPointerString CHECK -----------------");
    
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
    
    str = [NSString stringWithUTF8String:"abcdefgh"];      // length 8
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
    
    NSMutableString *mutableString = [NSMutableString stringWithString:@"1"];
    for(int i = 0; i < 16; i++){
        NSString *str = [NSString stringWithString:mutableString];
        NSLog(@"%@, %p, length: %ld", [str class], str, str.length);
        [mutableString appendString:@"1"];
    }
    
    NSLog(@"\n\n----------------- NSTaggedPointerString END -----------------");
    NSLog(@"\n\n");
    return result;
}


@end



