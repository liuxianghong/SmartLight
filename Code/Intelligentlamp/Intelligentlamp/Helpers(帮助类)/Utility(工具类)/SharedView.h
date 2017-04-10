//
//  SharedView.h
//  weixin
//
//  Created by L on 16/8/18.
//  Copyright © 2016年 L. All rights reserved.
//
//
#import <UIKit/UIKit.h>

@interface SharedView : UIView
@property (nonatomic , strong) UIView *currentView;//分享页面的底层view
@property (nonatomic , copy) dispatch_block_t shareSuccess;//分享成功回调
@property (nonatomic , copy) dispatch_block_t shareFail;//分享失败回调
@property (nonatomic , copy) dispatch_block_t shareCancel;//取消分享的回调

/**
 *  创建分享的单例
 *
 *  @return
 */
+ (SharedView *)shareInstance;

/**
 *  网络请求
 */
-(void)getCat;
/**
 *  移除分享view
 */
-(void)resetView;
/**
 *  分享view出现时的动画
 *
 *  @param duration 距离底部的高度
 */
-(void)showWithDuration:(CGFloat)duration;
/**
 *  分享方法
 *
 *  @param sucess 成功回调
 *  @param fail   失败回调
 *  @param cancel 取消回调
 */
-(void)addShareSuccess:(dispatch_block_t)sucess withFail:(dispatch_block_t)fail withCancel:(dispatch_block_t)cancel;
@end
