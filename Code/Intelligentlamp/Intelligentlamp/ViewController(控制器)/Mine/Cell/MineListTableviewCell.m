//
//  MineListTableviewCell.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "MineListTableviewCell.h"
#define TitleColor HEXCOLOR(0x4a4a4a)
#define BorderColor RGB(226, 226, 226)

@implementation MineListTableviewCell

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    switch (self.indexPath.row) {
        case 0:
            [self setUpLine:context withRect:rect];
            if (self.indexPath.section == 0)
                [self setMidLine:context withRect:rect];
            else
                [self setMidLine:context withRect:rect];
            break;
        case 3:
            [self setDownLine:context withRect:rect];
        default:
            [self setMidLine:context withRect:rect];
            break;
    }
}

-(void)setUpLine:(CGContextRef)context withRect:(CGRect)rect
{
    //上分割线，
    CGContextSetStrokeColorWithColor(context, AllLampLineColor.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width, 1));
}

-(void)setDownLine:(CGContextRef)context withRect:(CGRect)rect
{
    //底线
    CGContextSetStrokeColorWithColor(context, AllLampLineColor.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
}

-(void)setMidLine:(CGContextRef)context withRect:(CGRect)rect
{
    //下分割线
    CGContextSetStrokeColorWithColor(context, AllLampLineColor.CGColor);
    CGContextStrokeRect(context, CGRectMake(CGRectGetMinX(self.titleLab.frame), rect.size.height, rect.size.width-CGRectGetMinX(self.titleLab.frame), 1));
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = AllCellBgColor;
        [self initWithCell];
    }
    return self;
}

- (void)initWithCell{
    
    self.iconImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(32);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = [UIFont systemFontOfSize:15];
    self.titleLab.textColor = AllLampTitleColor;
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImg.mas_right).offset(8);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(100);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
   
    self.arrowImg = [[UIImageView alloc]init];
    self.arrowImg.image = [UIImage imageNamed:@"mine_jiantou2"];
    [self addSubview:self.arrowImg];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-18);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSString *image = dataDic[@"image"];
    self.iconImg.image = [UIImage imageNamed:image];
    self.titleLab.text = dataDic[@"name"];
    
}
@end
