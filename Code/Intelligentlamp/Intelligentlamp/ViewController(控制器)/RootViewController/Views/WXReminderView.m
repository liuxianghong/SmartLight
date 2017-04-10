//
//  WXReminderView.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "WXReminderView.h"
#import "UIView+CustomAnimation.h"
#define RemenderViewMaxHeight 30
@interface WXReminderView()

@property (nonatomic ,strong) UILabel *remindLab;
@property (nonatomic ,strong) UIImageView *sucessImg;
@property (nonatomic ,strong) UIImageView *maskImg;

@end

@implementation WXReminderView

- (UILabel *)remindLab{
    if (_remindLab == nil) {
        _remindLab = [[UILabel alloc]init];
        _remindLab.backgroundColor = [UIColor clearColor];
        _remindLab.textAlignment = NSTextAlignmentCenter;
        _remindLab.font = [UIFont systemFontOfSize:14];
        _remindLab.textColor = [UIColor whiteColor];
        _remindLab.numberOfLines = 1;
        _remindLab.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:_remindLab];
    }
    return _remindLab;
}

- (UIImageView *)sucessImg{
    if (_sucessImg == nil) {
        _sucessImg = [[UIImageView alloc]init];
        [self addSubview:_sucessImg];
    }
    return _sucessImg;
}

- (UIImageView *)maskImg{
    if (_maskImg == nil) {
        _maskImg = [[UIImageView alloc]init];
        [self addSubview:_maskImg];
    }
    return _maskImg;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (WXReminderView *)shareInstance{
    static dispatch_once_t once;
    static id shareInstance;
    _dispatch_once(&once, ^{
        shareInstance = [[self alloc]init];
    });
    return shareInstance;
}

- (void)addWarnmingRemind:(UIViewController *)addController warningString:(NSString *)str remindBlock:(dispatch_block_t)block{
    
    if (!str) {
        return;
    }
    self.remindBlock = block;
    [addController.view addSubview:self];
    [self showRemindViewAnimation:.3 withAnimationStopBlock:^{
        [self performSelector:@selector(hideReminderView) withObject:nil afterDelay:1.0];
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(addController.view);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.sucessImg.mas_leading).offset(-5);
        make.trailing.mas_equalTo(self.remindLab.mas_trailing).offset(5);
        make.centerY.mas_equalTo(self.sucessImg.mas_centerY);
        make.height.mas_equalTo(RemenderViewMaxHeight);
    }];
    [self.remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(self.sucessImg.image.size.width+10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(RemenderViewMaxHeight);
        make.width.mas_lessThanOrEqualTo([[UIScreen mainScreen] bounds].size.width - 20);
    }];
    self.sucessImg.image = [UIImage imageNamed:@"common_error"];
    [self.sucessImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.remindLab.mas_left).offset(-5);
        make.width.mas_equalTo(self.sucessImg.image.size.width/2);
        make.height.mas_equalTo(self.sucessImg.image.size.height/2);
        make.centerY.mas_equalTo(self.remindLab.mas_centerY);
    }];
    self.remindLab.text = str;

    
}


- (void)addSucessRemind:(UIViewController *)addController sucessString:(NSString *)str remindBlock:(dispatch_block_t)block{
    
    if (!str) {
        return;
    }
    self.remindBlock = block;
    [addController.view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(addController.view);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.sucessImg.mas_leading).offset(-5);
        make.trailing.mas_equalTo(self.remindLab.mas_trailing).offset(5);
        make.centerY.mas_equalTo(self.sucessImg.mas_centerY);
        make.height.mas_equalTo(RemenderViewMaxHeight);
    }];
    [self.remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(self.sucessImg.image.size.width+10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(RemenderViewMaxHeight);
        make.width.mas_lessThanOrEqualTo([[UIScreen mainScreen] bounds].size.width - 20);
    }];
    self.sucessImg.image = [UIImage imageNamed:@"common_success"];
    [self.sucessImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.remindLab.mas_left).offset(-5);
        make.width.mas_equalTo(self.sucessImg.image.size.width/2);
        make.height.mas_equalTo(self.sucessImg.image.size.height/2);
        make.centerY.mas_equalTo(self.remindLab.mas_centerY);
    }];
 
    self.remindLab.text = str;
    [addController.view addSubview:self];
    [self showRemindViewAnimation:.3 withAnimationStopBlock:^{
        [self performSelector:@selector(hideReminderView) withObject:nil afterDelay:1.0];
    }];

}


- (void)addWarningRemindWithView:(UIView *)addView warningString:(NSString *)str remindBlock:(dispatch_block_t)block
{
    if (!str) {
        return;
    }
    self.remindBlock = block;
    [addView addSubview:self];
    [self showRemindViewAnimation:.3 withAnimationStopBlock:^{
        [self performSelector:@selector(hideReminderView) withObject:nil afterDelay:1.0];
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(addView);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.sucessImg.mas_leading).offset(-5);
        make.trailing.mas_equalTo(self.remindLab.mas_trailing).offset(5);
        make.centerY.mas_equalTo(addView.mas_centerY);
        make.height.mas_equalTo(RemenderViewMaxHeight);
    }];
    [self.remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(10);
        make.centerY.mas_equalTo(self.mas_centerY).priorityMedium();
        make.height.mas_equalTo(RemenderViewMaxHeight);
        make.width.mas_lessThanOrEqualTo(ScreenWidth - 20);
    }];
    self.sucessImg.image = [UIImage imageNamed:@"common_error"];
    [self.sucessImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.remindLab.mas_left).offset(-10).priorityMedium();
        make.width.mas_equalTo(self.sucessImg.image.size.width/2);
        make.height.mas_equalTo(self.sucessImg.image.size.height/2);
        make.centerY.mas_equalTo(self.remindLab.mas_centerY).priorityMedium();
    }];
    
    self.remindLab.text = str;
}


- (void)addSuccessRemindWithView:(UIView *)addView remindString:(NSString *)str remindBlock:(dispatch_block_t)block
{
    if (!str) {
        return;
    }
    self.remindBlock = block;
    [addView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(addView);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.sucessImg.mas_leading).offset(-5);
        make.trailing.mas_equalTo(self.remindLab.mas_trailing).offset(5);
        make.centerY.mas_equalTo(addView.mas_centerY);
        make.height.mas_equalTo(RemenderViewMaxHeight);
    }];
    [self.remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(10);
        make.centerY.mas_equalTo(self.mas_centerY).priorityMedium();
        make.height.mas_equalTo(RemenderViewMaxHeight);
        make.width.mas_lessThanOrEqualTo(ScreenWidth - 20);
    }];
    self.sucessImg.image = [UIImage imageNamed:@"common_success"];
    [self.sucessImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.remindLab.mas_left).offset(-10);
        make.width.mas_equalTo(self.sucessImg.image.size.width/2);
        make.height.mas_equalTo(self.sucessImg.image.size.height/2);
        make.centerY.mas_equalTo(self.remindLab.mas_centerY);
    }];

    self.remindLab.text = str;
    [addView addSubview:self];
    [self showRemindViewAnimation:.3 withAnimationStopBlock:^{
        [self performSelector:@selector(hideReminderView) withObject:nil afterDelay:1.0];
    }];
    
}

- (void)hideReminderView{
    
    [self hideRemindViewAnimation:0.3 withAnimationStopBlock:^{
        [self removeFromSuperview];
        if (self.remindBlock) {
            self.remindBlock();
        }
    }];
}
@end
