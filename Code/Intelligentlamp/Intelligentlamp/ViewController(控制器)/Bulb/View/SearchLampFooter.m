//
//  SearchLampFooter.m
//  Intelligentlamp
//
//  Created by L on 16/9/9.
//  Copyright © 2016年 L. All rights reserved.
//

#import "SearchLampFooter.h"

@implementation SearchLampFooter

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = AllCellBgColor;
    }
    return self;
}

- (void)layoutFooterView{
    
    self.addLampBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.addLampBtn setImage:[UIImage imageNamed:@"common_error"] forState:UIControlStateNormal];
//    [self.addLampBtn setImage:[UIImage imageNamed:@"common_error"] forState:UIControlStateHighlighted];
    [self.addLampBtn setTitle:@"+ 连接设备" forState:UIControlStateNormal];
    self.addLampBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.addLampBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 70);
    [self.addLampBtn setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
    [self.addLampBtn addTarget:self action:@selector(addBuleClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addLampBtn];
    [self.addLampBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
