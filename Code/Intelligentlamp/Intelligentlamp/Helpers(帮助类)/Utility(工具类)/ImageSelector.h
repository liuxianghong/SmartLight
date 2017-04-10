//
//  ImageSelector.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

typedef NS_ENUM(NSInteger, ImageSelectorType) {
    ImageSelectorTypeCameraOnly,
    ImageSelectorTypeAlbumOnly,
    ImageSelectorTypeCameraAndAlbum
};

typedef NS_ENUM(NSInteger, ImageSelectorEditType) {
    ImageSelectorEditTypeSystem,
    ImageSelectorEditTypeCircular
};

typedef void (^SelectSuccessBlock)(NSArray *images);

#import <Foundation/Foundation.h>

@class RootViewController;


@interface ImageSelector : NSObject

/**
 *  单例
 *
 *  @return ImageSelector
 */
+ (instancetype)selector;

/**
 *  默认选择图片模式
 *
 *  @param viewController 控制器
 *  @param type           相机、相册
 *  @param allowEditing   是否允许编辑
 *  @param select         回调
 */
- (void)showSelectorAtControlloer:(RootViewController *)viewController type:(ImageSelectorType)type allowEditing:(BOOL)allowEditing afterSelect:(SelectSuccessBlock)select;

/**
 *  选择头像模式
 *
 *  @param viewController 控制器
 *  @param select         回调
 */
- (void)selectorAvatarAtControlloer:(RootViewController *)viewController afterSelect:(SelectSuccessBlock)select;


@end
