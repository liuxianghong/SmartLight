//
//  RootViewController.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "WXLoadingView.h"
#import "WXReminderView.h"
#import "WXNetworkingErrorView.h"
#import "LoginViewController.h"
#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = AllBgColor;
}

/**
 *  显示网络请求加载的view
 */
-(void)showNetWorkView
{
    [[WXLoadingView shareInstance] showLoadingViewWithViewController:self];
    [[WXLoadingView shareInstance] startLoadingAnimation];

}

/**
 *  隐藏网络请求加载的view（有猫头动画）
 */
-(void)hideNetWorkView
{
    [[WXLoadingView shareInstance] hideLoadingView];
    [[WXLoadingView shareInstance] stopLoadingAnimationAndHide];
}

/**
 *  显示提示成功的view
 */
-(void)showRemendSuccessView:(NSString *)remnder withBlock:(dispatch_block_t)block
{
    if (remnder == nil)
        return;
    [[WXReminderView shareInstance] addSucessRemind:self sucessString:remnder remindBlock:block];
}
/**
 *  显示提示失败的view
 */
-(void)showRemendWarningView:(NSString *)remnder withBlock:(dispatch_block_t)block
{
    if (remnder == nil)
        return;
    [[WXReminderView shareInstance] addWarnmingRemind:self warningString:remnder remindBlock:block];
}
/**
 *  隐藏提示的view
 */
-(void)hideRemendView
{
    [[WXReminderView shareInstance] hideReminderView];
}

/**
 *  显示提示失败的view（有猫头动画）
 */
-(void)showNetErrorView:(NSString *)remnder
{
    [[WXNetworkingErrorView shareInstance] showNetErrorView:self withRemind:remnder];
}
/**
 *  隐藏提示的view（有猫头动画）
 */
-(void)hideNetErrorView
{
    [[WXNetworkingErrorView shareInstance] hideNetErrorView];

}

-(void)setTitleViewWithCustomView:(UIView *)view
{
    self.navigationItem.titleView = view;
}

-(void)setTitleViewWithStr:(NSString *)str
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    [titleLabel sizeThatFits:CGSizeMake(ScreenWidth-100, 40)];
    titleLabel.textColor = AllLampTitleColor;
    titleLabel.text = str;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}

//#pragma - mark ViewController 生命周期
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeFinish) name:UIApplicationDidBecomeActiveNotification object:nil];
//}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//#pragma - mark NotificationCenter 回调方法
//-(void)noticeFinish
//{
//    [[LMLoadingView shareInstance] startLoadingAnimation];
//}

- (void)leftBarButtonsItemWithShutDownBlock:(dispatch_block_t)ShutDownBlock withBackBlock:(dispatch_block_t)backBlock
{
    WXBarButtonItem *shutDownItem = [[WXBarButtonItem alloc] initWithImage:nil withTitle:@"关闭" withBtnType:ButtonLeft withClickBtnActionBlock:ShutDownBlock];
    self.backItem = [[WXBarButtonItem alloc] initWithImage:nil withTitle:@"返回" withBtnType:ButtonLeft withClickBtnActionBlock:backBlock];
    self.navigationItem.leftBarButtonItems = @[shutDownItem , self.backItem];
}

- (void)leftBarButtonItem:(UIImage *)leftImg withClickBtnAction:(ClickBtnAction)block
{
    if (!leftImg) {
//        leftImg = [UIImage imageNamed:];
    }
    WXBarButtonItem *leftItem = [[WXBarButtonItem alloc] initWithImage:leftImg withTitle:nil withBtnType:ButtonLeft withClickBtnActionBlock:block];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)rightBarButtonItem:(UIImage *)rightImg withClickBtnAction:(ClickBtnAction)block
{
    if (!rightImg) {
        //        rightImg = [@"common_error" getCommonBundleImage];
    }
    WXBarButtonItem *rightItem = [[WXBarButtonItem alloc] initWithImage:rightImg withTitle:nil withBtnType:ButtonRight withClickBtnActionBlock:block];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)leftBarButtonItemWithTitle:(NSString *)title withClickBtnAction:(ClickBtnAction)block
{
    WXBarButtonItem *leftItem = [[WXBarButtonItem alloc] initWithImage:nil withTitle:title withBtnType:ButtonLeft withClickBtnActionBlock:block];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)rightBarButtonItemWithTitle:(NSString *)title withClickBtnAction:(ClickBtnAction)block
{
    WXBarButtonItem *rightItem = [[WXBarButtonItem alloc] initWithImage:nil withTitle:title withBtnType:ButtonRight withClickBtnActionBlock:block];
    self.navigationItem.rightBarButtonItem = rightItem;
}




@end
