//
//  AllScenarioCell.m
//  Intelligentlamp
//
//  Created by L on 16/8/21.
//  Copyright © 2016年 L. All rights reserved.
//
#define AllBulbTitleColor HEXCOLOR(0x8c8c8e)
#define AllBulbDescribeColor HEXCOLOR(0x8c8c8e)
#define AllBulbLineColor HEXCOLOR(0x19181b)
#define AllCellBgColor RGB(28,27,31)

#import "AllScenarioCell.h"
#import "AllScenarioModel.h"

@implementation AllScenarioCell

- (void)drawRect:(CGRect)rect{
    CGContextRef context             = UIGraphicsGetCurrentContext();
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
    self                             = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithCell];
    self.backgroundColor             = AllCellBgColor;

    }
    return self;
}

- (void)initWithCell{

    self.iconImg                     = [[UIImageView alloc]init];
    self.iconImg.image               = [UIImage imageNamed:@"scene_avatar"];
    self.iconImg.layer.masksToBounds = YES;
    self.iconImg.layer.cornerRadius  = 16;//设置为图片宽度的一半出来为圆形
    self.iconImg.layer.borderWidth   = 1.0f;//边框宽度
    self.iconImg.layer.borderColor=[[UIColor whiteColor] CGColor];//边框颜色

    [self.contentView addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(32);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    self.titleLab                    = [[UILabel alloc] init];
    self.titleLab.font               = [UIFont systemFontOfSize:15];
    self.titleLab.textColor          = AllBulbTitleColor;
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImg.mas_right).offset(15);
        make.height.mas_equalTo(18);
        make.width.mas_greaterThanOrEqualTo(100);
        make.top.mas_equalTo(8);
    }];

    self.describeLab                 = [[UILabel alloc]init];
    self.describeLab.font            = [UIFont systemFontOfSize:12];
    self.describeLab.textColor       = AllBulbDescribeColor;
    [self.contentView addSubview:self.describeLab];
    [self.describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(8);
        make.left.mas_equalTo(self.iconImg.mas_right).offset(15);
        make.width.mas_greaterThanOrEqualTo(100);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-8);

    }];


    self.setUpBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setUpBtn addTarget:self action:@selector(setUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.setUpBtn setBackgroundImage:[UIImage imageNamed:@"COG"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.setUpBtn];
    [self.setUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(self.mas_right).offset(-8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    UILabel *line                    = [[UILabel alloc]init];
    line.backgroundColor             = AllBulbLineColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-61);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(61);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];


}

- (void)setUpBtnClick{
    if (self.setUpBlock) {
        self.setUpBlock(self.indexPath);
    }
}


- (void)setModel:(AllScenarioModel *)model{
    _model                           = model;
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:model.ScenarioImg]];
    _describeLab.text                = model.ScenarioDescribe;
    _titleLab.text                   = model.ScenarioTitle;

}
@end

