//
//  AddLampFooterView.m
//  Intelligentlamp
//
//  Created by L on 16/8/21.
//  Copyright © 2016年 L. All rights reserved.
//
#define AllBulbTitleColor HEXCOLOR(0x8c8c8e)

#import "AddLampFooterView.h"

@implementation AddLampFooterView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = AllCellBgColor;
    }
    return self;
}

- (void)layoutFooterView{
    
    self.addGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.addGroupBtn setImage:[UIImage imageNamed:@"common_error"] forState:UIControlStateNormal];
//    [self.addGroupBtn setImage:[UIImage imageNamed:@"common_error"] forState:UIControlStateHighlighted];
    [self.addGroupBtn setTitle:@"+ 添加灯泡" forState:UIControlStateNormal];
    self.addGroupBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.addGroupBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 70);
    [self.addGroupBtn setTitleColor:AllBulbTitleColor forState:UIControlStateNormal];
    [self.addGroupBtn addTarget:self action:@selector(addBuleClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addGroupBtn];
    [self.addGroupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(35);
        make.width.mas_equalTo(100);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.top.mas_equalTo(10);
    }];
    
}

- (void)addBuleClick{
    if (self.addLampBlock) {
        self.addLampBlock();
    }
}
@end

