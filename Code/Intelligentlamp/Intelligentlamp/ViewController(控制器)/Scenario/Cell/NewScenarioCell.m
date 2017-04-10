//
//  NewScenarioCell.m
//  Intelligentlamp
//
//  Created by L on 16/9/26.
//  Copyright © 2016年 L. All rights reserved.
//

#import "NewScenarioCell.h"
#import "AllScenarioModel.h"

@implementation NewScenarioCell

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        [self addSubview:_bgView];
        _bgView.backgroundColor = AllCellBgColor;
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
    }
    return _bgView;
}

- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]init];
        [_bgImgView setImage:[UIImage imageNamed:@"mine_bg"]];
        [_bgView addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top);
            make.left.mas_equalTo(_bgView.mas_left);
            make.right.mas_equalTo(_bgView.mas_right);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-35);
        }];
    }
    return _bgImgView;
}
- (UIButton *)setUpBtn{
    if (!_setUpBtn) {
        _setUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.setUpBtn addTarget:self action:@selector(setUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_setUpBtn setImage:[UIImage imageNamed:@"COG"] forState:UIControlStateNormal];
        [_bgView addSubview:_setUpBtn];
        [_setUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
            make.top.mas_equalTo(_bgImgView.mas_bottom).offset(0);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
        }];
    }
    return _setUpBtn;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"标题";
        _titleLabel.textColor = AllLampTitleColor;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [_bgView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgImgView.mas_bottom).offset(7);
            make.left.mas_equalTo(_bgView.mas_left).mas_equalTo(15);
            make.right.mas_equalTo(_setUpBtn.mas_left).offset(-10);
        }];
    }
    
    return _titleLabel;
}

- (void)setModel:(AllScenarioModel *)model{
    _model                           = model;
    [self bgView];
    [self bgImgView];
    [self setUpBtn];
    [self titleLabel];
    
    [_bgImgView sd_setImageWithURL:[NSURL URLWithString:model.ScenarioImg]];
//    _describeLab.text                = model.ScenarioDescribe;
    _titleLabel.text                   = model.ScenarioTitle;
    
}

- (void)setUpBtnClick{
    if (self.setUpBlock) {
        self.setUpBlock(self.indexPath);
    }
}
@end
