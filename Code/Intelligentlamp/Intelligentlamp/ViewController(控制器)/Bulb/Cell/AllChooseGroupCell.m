//
//  AllChooseGroupCell.m
//  Intelligentlamp
//
//  Created by L on 16/9/18.
//  Copyright © 2016年 L. All rights reserved.
//

#import "AllChooseGroupCell.h"
#import "AllGroupModel.h"
#import "AllScenarioModel.h"

@implementation AllChooseGroupCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = AllTitleColor;
    _bgView.layer.masksToBounds=YES;
    _bgView.layer.cornerRadius=16; //设置为图片宽度的一半出来为圆形
    _bgView.layer.borderWidth=1.0f; //边框宽度
    _bgView.layer.borderColor=[AllBgColor CGColor];//边框颜色
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(66);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    self.iconImg = [[UIImageView alloc]init];
    self.iconImg.layer.masksToBounds=YES;
    self.iconImg.layer.cornerRadius=25; //设置为图片宽度的一半出来为圆形
    self.iconImg.layer.borderWidth=1.0f; //边框宽度
    self.iconImg.layer.borderColor=[AllTitleColor CGColor];//边框颜色
    
    [_bgView addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
        make.centerX.mas_equalTo(_bgView.mas_centerX);
        make.centerY.mas_equalTo(_bgView.mas_centerY);
    }];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.text = @"mingzi";
    self.titleLab.font = [UIFont systemFontOfSize:12];
    self.titleLab.textColor = AllLampTitleColor;
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_lessThanOrEqualTo(90);
        make.top.mas_equalTo(_bgView.mas_bottom);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    return self;
}

- (void)setModel:(AllGroupModel *)model{
    _model = model;
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:model.groupImg]];
    _titleLab.text = model.groupTitle;
}

- (void)setScenario:(AllScenarioModel *)scenario{
    _scenario = scenario;
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:scenario.ScenarioImg]];
    _titleLab.text = scenario.ScenarioTitle;
}
@end
