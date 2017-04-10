//
//  SelectLampCell.m
//  Intelligentlamp
//
//  Created by L on 16/8/21.
//  Copyright © 2016年 L. All rights reserved.
//
#define AllBulbTitleColor HEXCOLOR(0x8c8c8e)
#define AllBulbDescribeColor HEXCOLOR(0x8c8c8e)
#define AllBulbLineColor HEXCOLOR(0x19181b)
#define AllCellBgColor RGB(28,27,31)
#import "SelectLampCell.h"
#import "GroupLampModel.h"

@implementation SelectLampCell

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    [self setDownLine:context withRect:rect];
    
}

-(void)setDownLine:(CGContextRef)context withRect:(CGRect)rect
{
    //底线
    CGContextSetStrokeColorWithColor(context, AllBulbLineColor.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithCell];
        self.backgroundColor = AllCellBgColor;
        
    }
    return self;
}

- (void)initWithCell{
    
    self.iconImg = [[UIImageView alloc]init];
    self.iconImg.image = [UIImage imageNamed:@"common_faxian_2"];
    
    [self.contentView addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(32);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.text = @"mingzi";
    self.titleLab.font = [UIFont systemFontOfSize:15];
    self.titleLab.textColor = AllBulbTitleColor;
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImg.mas_right).offset(15);
        make.height.mas_equalTo(18);
        make.width.mas_greaterThanOrEqualTo(100);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    
    self.setUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setUpBtn addTarget:self action:@selector(setUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.setUpBtn];
    [self.setUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(self.mas_right).offset(-8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = AllBulbLineColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-61);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(61);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    
}

- (void)setUpBtnClick{
    if (self.selectBlock) {
        self.selectBlock(self.indexPath);
    }
    
    if (_model.isSelected) {
        [self.setUpBtn setBackgroundImage:[UIImage imageNamed:@"灯泡未选取"] forState:UIControlStateNormal];
        _model.isSelected = NO;
    }else{
        [self.setUpBtn setBackgroundImage:[UIImage imageNamed:@"灯泡已选取"] forState:UIControlStateNormal];
        _model.isSelected = YES;
    }
}


- (void)setModel:(GroupLampModel *)model{
    _model = model;
    _iconImg.image = [UIImage imageNamed:model.lampImg];
    _titleLab.text = model.lampName;
    
    if (_model.isSelected) {
        [self.setUpBtn setBackgroundImage:[UIImage imageNamed:@"灯泡已选取"] forState:UIControlStateNormal];
    }else{
        [self.setUpBtn setBackgroundImage:[UIImage imageNamed:@"灯泡未选取"] forState:UIControlStateNormal];
    }

    
}
@end


