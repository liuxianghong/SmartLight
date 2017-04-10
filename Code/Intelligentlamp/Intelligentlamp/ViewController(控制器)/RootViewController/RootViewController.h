//
//  RootViewController.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXBarButtonItem.h"

@interface RootViewController : UIViewController

@property (nonatomic ,strong) WXBarButtonItem *backItem;
/**
 *  显示网络请求加载的view
 */
-(void)showNetWorkView;
/**
 *  隐藏网络请求加载的view
 */
-(void)hideNetWorkView;

/**
 *  显示提示成功的view
 */
-(void)showRemendSuccessView:(NSString *)remnder withBlock:(dispatch_block_t)block;
/**
 *  显示提示失败的view
 */
-(void)showRemendWarningView:(NSString *)remnder withBlock:(dispatch_block_t)block;
/**
 *  隐藏提示的view
 */
-(void)hideRemendView;

/**
 *  显示提示网络失败的view
 */
-(void)showNetErrorView:(NSString *)remnder;
/**
 *  隐藏提示网络失败的view
 */
-(void)hideNetErrorView;

/**
 *  显示登录页面
 */
-(void)showLoginView;


-(void)setTitleViewWithStr:(NSString *)str;
-(void)setTitleViewWithCustomView:(UIView *)view;

- (void)leftBarButtonItem:(UIImage *)leftImg withClickBtnAction:(ClickBtnAction)block;
- (void)rightBarButtonItem:(UIImage *)rightImg withClickBtnAction:(ClickBtnAction)block;

- (void)leftBarButtonItemWithTitle:(NSString *)title withClickBtnAction:(ClickBtnAction)block;
- (void)rightBarButtonItemWithTitle:(NSString *)title withClickBtnAction:(ClickBtnAction)block;


- (void)leftBarButtonsItemWithShutDownBlock:(dispatch_block_t)ShutDownBlock withBackBlock:(dispatch_block_t)backBlock;

@end
