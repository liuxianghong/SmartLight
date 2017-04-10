//
//  AvatorHelper.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^FinishBlock)(UIImage *image);

typedef void(^FinishedBlock)(UIImage *image);

@interface AvatorHelper : NSObject

@property(nonatomic ,strong) UIViewController *currentVC;//当前正在使用的VC

@property(nonatomic ,copy) FinishBlock finishBlock;//图片选择完成block


/**
 *  单例
 *
 *  @return
 */
+ (AvatorHelper *)shareInstance;

/**
 *  显示头像截取的页面
 *
 *  @param cropImage 被剪裁的图片
 *  @param vc        传入当前工作的VC
 */
- (void)showEditVC:(UIImage *)cropImage withVC:(UIViewController *)vc;

/**
 *  选择图片完成
 *
 *  @param block 完成的回调
 */
- (void)addChoseImageFinish:(void(^)(UIImage *image))block;


@end
