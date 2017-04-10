//
//  LampNodataView.m
//  Intelligentlamp
//
//  Created by L on 16/8/29.
//  Copyright © 2016年 L. All rights reserved.
//

#import "LampNodataView.h"
#import "RootViewController.h"

@implementation LampNodataView

+(LampNodataView *)shareInstance{
    static dispatch_once_t once;
    static LampNodataView *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(UIButton *)promptImageView{
    if (_promptImageView == nil) {
        _promptImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_promptImageView addTarget:self action:@selector(promptBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_promptImageView setImage:[UIImage imageNamed:@"Add_btn_UnPressed"] forState:UIControlStateNormal];
//        _promptImageView.image = [UIImage imageNamed:@"Add_btn_UnPressed"];
        [self addSubview:_promptImageView];
        [_promptImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-80);
            make.width.mas_equalTo(@80);
            make.height.mas_equalTo(@80);
        }];
    }
    return _promptImageView;
}

-(UILabel *)promptLabel{
    if (_promptLabel == nil) {
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.text = @"你是什么鬼啊";
        _promptLabel.textColor = AllLampTitleColor;
        _promptLabel.font = [UIFont systemFontOfSize:13];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_promptLabel];
        [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(0);
            make.width.mas_equalTo(self.mas_width).offset(-20);
            make.height.mas_equalTo(@30);
        }];
    }
    return _promptLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = AllBgColor;
    }
    return self;
}

- (void)initInSuperView:(UIView *)superView
         withPictureUrl:(NSString *)pictureUrl
              withTitle:(NSString *)title{
    [superView addSubview:self];
    //    if ([superView isKindOfClass:[UITableView class]]) {
    //        [superView sendSubviewToBack:self];
    //    }
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(superView.mas_centerX);
        make.centerY.mas_equalTo(superView.mas_centerY);
        make.width.mas_equalTo(superView.mas_width);
        make.height.mas_equalTo(superView.mas_height);
    }];
    [self.promptImageView class];
    self.promptLabel.text = title;
}

- (void)initInSuperVC:(RootViewController *)superVC
       withPictureUrl:(NSString *)pictureUrl
            withTitle:(NSString *)title{
    
    [superVC.view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superVC.view);
    }];
    [self.promptImageView class];
    self.promptLabel.text = title;
    
}

-(void)hideSupview
{
    [self removeFromSuperview];
}

@end
