//
//  WXNetworkingErrorView.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "WXNetworkingErrorView.h"

@implementation WXNetworkingErrorView


- (UIImageView *)reminderImg{
    if (_reminderImg == nil) {
        _reminderImg = [[UIImageView alloc] init];
//        _reminderImg.image = [UIImage imageNamed:];
        _reminderImg.backgroundColor = [UIColor redColor];
        [self addSubview:_reminderImg];
        [_reminderImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-20);
            make.width.mas_equalTo(_reminderImg.image.size.width);
            make.height.mas_equalTo(_reminderImg.image.size.height);
        }];

    }
    return _reminderImg;
}

- (UILabel *)reminderLab{
    if (_reminderLab == nil) {
        _reminderLab = [[UILabel alloc] init];
        _reminderLab.backgroundColor = [UIColor blueColor];
        _reminderLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_reminderLab];
        [_reminderLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reminderImg.mas_bottom).offset(10);
            make.centerX.equalTo(self.mas_centerX);
            make.leading.equalTo(self.mas_leading).offset(10);
            make.trailing.equalTo(self.mas_trailing).offset(-10);
        }];
    }
    return _reminderLab;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = AllBgColor;
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideNetErrorView)]];
    }
    return self;
}

+ (WXNetworkingErrorView *)shareInstance{
    static dispatch_once_t once;
    static WXNetworkingErrorView *shareInstance;
    dispatch_once(&once, ^{
        shareInstance = [[self alloc]init];
    });
    return shareInstance;
}

- (void)showNetErrorView:(UIViewController *)viewController withRemind:(NSString *)str
{
    [viewController.view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewController.view);
    }];
    [self.reminderImg class];
    self.reminderLab.text = str;
}
- (void)hideNetErrorView
{
    [self removeFromSuperview];
}
@end
