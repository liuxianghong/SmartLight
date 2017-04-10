//
//  ImageSelector.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#define UseCameraString @"拍照"
#define UseAlbumString @"相册"
#define CancelString @"取消"

#import "ImageSelector.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "AvatorHelper.h"


@interface ImageSelector()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) RootViewController *superVC;
@property (nonatomic, assign) ImageSelectorType selectType;
@property (nonatomic, assign) ImageSelectorEditType editType;
@property (nonatomic, copy) SelectSuccessBlock afterSelect;
@property (nonatomic, assign) BOOL allowEditing;


@end
@implementation ImageSelector

#pragma mark - init


+ (instancetype)selector {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 默认模式
- (void)showSelectorAtControlloer:(RootViewController *)viewController type:(ImageSelectorType)type allowEditing:(BOOL)allowEditing afterSelect:(SelectSuccessBlock)select {
    _superVC = viewController;
    _selectType = type;
    _editType = ImageSelectorEditTypeSystem;
    _afterSelect = select;
    _allowEditing = NO;
    
    if (!self.superVC) {
        return;
    }
    
    [self showActionSheet];
}


#pragma mark - 头像模式
- (void)selectorAvatarAtControlloer:(RootViewController *)viewController afterSelect:(SelectSuccessBlock)select {
    _superVC = viewController;
    _selectType = ImageSelectorTypeCameraAndAlbum;
    _editType = ImageSelectorEditTypeCircular;
    _afterSelect = select;
    _allowEditing = NO;
    
    if (!self.superVC) {
        return;
    }
    
    [self showActionSheet];
}


- (void)showActionSheet {
    //iOS7和更低版本使用UIActionSheet
    if (iOS7_AndEarlier) {
        
        UIActionSheet *sheet;
        switch (self.selectType) {
            case ImageSelectorTypeCameraOnly:
                sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:CancelString destructiveButtonTitle:nil otherButtonTitles:UseCameraString, nil];
                break;
                
            case ImageSelectorTypeAlbumOnly:
                sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:CancelString destructiveButtonTitle:nil otherButtonTitles:UseCameraString, nil];
                break;
                
            case ImageSelectorTypeCameraAndAlbum:
                sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:CancelString destructiveButtonTitle:nil otherButtonTitles:UseCameraString,UseAlbumString, nil];
                break;
                
            default:
                break;
        }
        
        [sheet showInView:ApplicationDelegate.window];
    }
    //iOS8及其以上版本使用UIActionController
    else {
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:UseCameraString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self wakeUpSystemTypeCamera];
        }];
        UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:UseAlbumString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self wakeUpSystemTypeAlbum];
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:CancelString style:UIAlertActionStyleCancel handler:nil];
        
        switch (self.selectType) {
            case ImageSelectorTypeCameraOnly:
            {
                [sheet addAction:actionCamera];
                [sheet addAction:actionCancel];
            }
                break;
                
            case ImageSelectorTypeAlbumOnly:
            {
                [sheet addAction:actionAlbum];
                [sheet addAction:actionCancel];
            }
                break;
                
            case ImageSelectorTypeCameraAndAlbum:
            {
                [sheet addAction:actionCamera];
                [sheet addAction:actionAlbum];
                [sheet addAction:actionCancel];
            }
                break;
                
            default:
                break;
        }
        
        [self.superVC presentViewController:sheet animated:YES completion:nil];
    }
}





#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:UseCameraString]) {
        [self wakeUpSystemTypeCamera];
    }
    else if ([title isEqualToString:UseAlbumString]) {
        [self wakeUpSystemTypeAlbum];
    }
}



#pragma mark - 相机
- (void)wakeUpSystemTypeCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
#warning 相机不可用提示
        [self.superVC showRemendWarningView:@"相机不可用" withBlock:nil];
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = self.allowEditing;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    imagePickerController.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
    
    [self.superVC presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - 相册
- (void)wakeUpSystemTypeAlbum {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = self.allowEditing;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    
    [self.superVC presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - 使用图片
- (void)useImage:(UIImage *)image {
    if (self.afterSelect) {
        self.afterSelect(@[image]);
    }
}



#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    
    //获取图片
    UIImage *result = info[self.allowEditing?UIImagePickerControllerEditedImage:UIImagePickerControllerOriginalImage];
    
    //方向fix
//    if (result && [result isKindOfClass:[UIImage class]]) {
//        result = [result fixOrientation];
//    }
    
    if (self.editType == ImageSelectorEditTypeSystem) {
        //系统编辑
        [picker dismissViewControllerAnimated:YES completion:^{
            [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:result];
        }];
    }
    else if (self.editType == ImageSelectorEditTypeCircular) {
        //圆形编辑
        [picker dismissViewControllerAnimated:YES completion:^{
            AvatorHelper *helper = [AvatorHelper shareInstance];
            [helper showEditVC:result withVC:self.superVC];
            [helper addChoseImageFinish:^(UIImage *image) {
                if (self.afterSelect) {
                    self.afterSelect(@[image]);
                }
            }];
        }];
        
    }
    
    
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}



@end

