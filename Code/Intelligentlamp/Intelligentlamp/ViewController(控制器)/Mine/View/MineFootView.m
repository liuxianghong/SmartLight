//
//  MineFootView.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "MineFootView.h"
#define TitleColor HEXCOLOR(0x4a4a4a)
#define BorderColor RGB(226, 226, 226)
@implementation MineFootView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = AllCellBgColor;
    }
    return self;
}

- (void)layoutMineFootView{
    
    self.exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.exitBtn setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
    [self.exitBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    self.exitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.exitBtn];
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.top.mas_equalTo(self.mas_top).offset(9);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(self);
    }];
}

- (void)clickLoginBtn{
    if (self.exitClickBlock) {
        self.exitClickBlock();
    }
}
@end
