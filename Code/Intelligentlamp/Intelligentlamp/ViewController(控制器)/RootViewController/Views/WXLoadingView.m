//
//  WXLoadingView.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "WXLoadingView.h"
@interface WXLoadingView()

@property (nonatomic ,strong) UIImageView *animationImgView;//转圈动画图片
@property (nonatomic ,strong) UIImageView *animationImg;//加载动画图片
@end

@implementation WXLoadingView

- (UIImageView *)animationImg{
    if (_animationImg == nil) {
        _animationImg = [[UIImageView alloc]init];
        _animationImg.image = [UIImage imageNamed:@"common_loading1"];
    }
    return _animationImg;
}

- (UIImageView *)animationImgView{
    if (_animationImgView == nil) {
        _animationImgView = [[UIImageView alloc]init];
        _animationImgView.image = [UIImage imageNamed:@"common_loading"];
    }
    return _animationImgView;
}

+ (WXLoadingView *)shareInstance{
    static dispatch_once_t once;
    static WXLoadingView *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc]init];
    });
    return instance;
}
//loadingView的初始化
- (instancetype)init
{
    self                                   = [super init];
    if (self) {
        UIImageView *maskView = [[UIImageView alloc] init];
        [self addSubview:maskView];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.8;
        maskView.layer.cornerRadius = 10;
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@65);
            make.height.equalTo(@65);
            make.center.equalTo(self);
        }];
    }
    return self;
}

- (void)showLoadingViewWithViewController:(UIViewController *)addViewController;
{
    WXLoadingView *loadingView             = [WXLoadingView shareInstance];
    [loadingView addSubview:self.animationImgView];
    [loadingView addSubview:self.animationImg];
    [addViewController.view addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(addViewController.view);
    }];
    [self.animationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(loadingView);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    [self.animationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(loadingView);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    loadingView.alpha                      = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        loadingView.alpha                      = 1.0;
    }];
    
}
-(void)hideLoadingView
{
    [self removeFromSuperview];
}

-(void)startLoadingAnimation
{
    CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.removedOnCompletion = FALSE;
    rotate.fillMode = kCAFillModeForwards;
    [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
    rotate.repeatCount = MAXFLOAT;
    rotate.duration = 0.25;
    rotate.cumulative = TRUE;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_animationImgView.layer addAnimation:rotate forKey:@"rotateAnimation"];
}

-(void)stopLoadingAnimationAndHide
{
    [self.animationImgView.layer removeAllAnimations];
    [WXLoadingView shareInstance].alpha    = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        [WXLoadingView shareInstance].alpha    = 0.0;
    } completion:^(BOOL finished) {
        [[WXLoadingView shareInstance] removeFromSuperview];
    }];
}

-(void)dealloc
{
    self.animationImgView                = nil;
}
@end

