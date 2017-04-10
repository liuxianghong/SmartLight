//
//  NoLampHeaderView.m
//  Intelligentlamp
//
//  Created by L on 16/8/25.
//  Copyright © 2016年 L. All rights reserved.
//

#import "NoLampHeaderView.h"

@implementation NoLampHeaderView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = AllCellBgColor;
    }
    return self;
}

- (void)layoutNoLampHeaderView{
    
    _addLampBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addLampBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_addLampBtn setBackgroundImage:[UIImage imageNamed:@"Add_btn_UnPressed"] forState:UIControlStateNormal];
    [_addLampBtn setBackgroundImage:[UIImage  imageNamed:@"Add_btn_Pressed"] forState:UIControlStateHighlighted];
    
    [_addLampBtn addTarget:self action:@selector(addLampBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addLampBtn];
    [_addLampBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-100);
    }];
    
    _promptLab = [[UILabel alloc]init];
    _promptLab.textColor = AllLampTitleColor;
    _promptLab.textAlignment = NSTextAlignmentCenter;
    _promptLab.font = [UIFont systemFontOfSize:13];
    _promptLab.text = @"没有数据";
    [self addSubview:_promptLab];
    [_promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(35);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_addLampBtn.mas_bottom).offset(15);
    }];
    

}

- (void)addLampBtnClick{
    if (self.addLampBlock) {
        self.addLampBlock();
    }
}

@end
