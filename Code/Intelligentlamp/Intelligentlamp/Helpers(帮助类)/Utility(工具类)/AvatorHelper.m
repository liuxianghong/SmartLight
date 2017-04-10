//
//  AvatorHelper.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "AvatorHelper.h"
#import "UIImage+CircleCrop.h"
#import "RSKImageCropViewController.h"

@interface AvatorHelper ()<RSKImageCropViewControllerDelegate>

@end
@implementation AvatorHelper

+ (AvatorHelper *)shareInstance{
    static dispatch_once_t once;
    static id shareInstance;
    dispatch_once(&once, ^{
        shareInstance = [[self alloc]init];
    });
    
    return shareInstance;
}

-(void)showEditVC:(UIImage *)cropImage withVC:(UIViewController *)vc
{
    RSKImageCropViewController *controller = [[RSKImageCropViewController alloc] initWithImage:cropImage cropMode:RSKImageCropModeCircle];
    self.currentVC                              = vc;
    [controller.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [controller.chooseButton setTitle:@"确定" forState:UIControlStateNormal];
    controller.moveAndScaleLabel.text      = @"拖动放大";
    controller.avoidEmptySpaceAroundImage = YES;
    controller.delegate                    = self;
    [self.currentVC presentViewController:controller animated:YES completion:nil];
}

-(void)addChoseImageFinish:(void(^)(UIImage *image))block
{
    self.finishBlock                            = block;
}

#pragma -mark RSKImageCropViewControllerDelegate and RSKImageCropViewControllerDataSource

-(void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    if (self.finishBlock) {
        UIImage *image                         = [croppedImage cutImageWithRadius:croppedImage.size.width/2];
        self.finishBlock(image);
    }
    [self.currentVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.currentVC dismissViewControllerAnimated:YES completion:nil];
}

@end
