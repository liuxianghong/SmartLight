//
//  AllLampSpeciesCell.m
//  Intelligentlamp
//
//  Created by L on 16/8/25.
//  Copyright © 2016年 L. All rights reserved.
//所有的灯泡种类cell

#import "AllLampSpeciesCell.h"
#import "AllLampSpeciesModel.h"


@implementation AllLampSpeciesCell

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    [self setDownLine:context withRect:rect];
    
}

-(void)setDownLine:(CGContextRef)context withRect:(CGRect)rect
{
    //底线
    CGContextSetStrokeColorWithColor(context, AllLampLineColor.CGColor);
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
//    self.iconImg.image = [UIImage imageNamed:@"common_faxian_2"];
    self.iconImg.layer.masksToBounds=YES;
    self.iconImg.layer.cornerRadius=16; //设置为图片宽度的一半出来为圆形
    self.iconImg.layer.borderWidth=1.0f; //边框宽度
    self.iconImg.layer.borderColor=[[UIColor whiteColor] CGColor];//边框颜色
    
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
    self.titleLab.textColor = AllLampTitleColor;
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImg.mas_right).offset(15);
        make.height.mas_equalTo(32);
        make.width.mas_greaterThanOrEqualTo(100);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];


}

- (void)setModel:(AllLampSpeciesModel *)model{
    _model = model;
    
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:model.lampImg]];
    _titleLab.text = model.lampTitle;
}
@end
