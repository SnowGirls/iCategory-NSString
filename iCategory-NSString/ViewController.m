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
    
    // First, open Photos App, and add some album with name manually ~~~
    
    // Second, run this app and grant all photo permissions, the click the button below ~~~
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    [button setTitle:@"Click me" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickMe:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    NSLog(@"\n\n----------------- NSTaggedPointerString CHECK -----------------");
    
    TaggedPointerModel* model = [[TaggedPointerModel alloc] init];
    NSLog(@"------->>>>> longTitle: %s, %@",(const char *)class_getName([model.longTitle class]),  model.longTitle);
    NSLog(@"------->>>>> shortTitle: %s, %@", (const char *)class_getName([model.shortTitle class]), model.shortTitle);
    
    NSString *strS = @"1234567";
    NSLog(@"%@ : %p, %@", strS.class, strS, strS);
    
    strS = [NSString stringWithUTF8String:"1234567"];       // length 7
    NSLog(@"%@ : %p, %@", strS.class, strS, strS);
    
    strS = [NSString stringWithUTF8String:"abcdabcd"];      // length 8
    NSLog(@"%@ : %p, %@", strS.class, strS, strS);
    
    strS = [NSString stringWithUTF8String:"eeeeeeeeeee"];   // length 11
    NSLog(@"%@ : %p, %@", strS.class, strS, strS);
    
    strS = [NSString stringWithUTF8String:"eeeeeeeeeeee"];  // length 12
    NSLog(@"%@ : %p, %@", strS.class, strS, strS);
    
    NSLog(@"\n\n----------------- NSTaggedPointerString END -----------------");
}

- (void)clickMe:(UIButton *)button {
    PHFetchResult *photoStreamAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
    PHFetchResult *userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    NSArray *albums = @[photoStreamAlbums, smartAlbums, syncedAlbums, sharedAlbums, userAlbums];
    
    for (int i = 0; i < albums.count; i++) {
        PHFetchResult *fetchResult = albums[i];
        for (PHAssetCollection *collection in fetchResult) {
            // Access the collection.localizedTitle
            
            // Will crash when reach userAlbums. if you have a NSString category with + (void)initialize method override
            NSLog(@">>>>>>>>>>>> album name: %@", collection.localizedTitle);
            
            // Uncomment the `[NSString invokeOriginalMethod:self selector:_cmd];` code, then will not crash :P
            // Try yourself :)
        }
    }
}


@end
