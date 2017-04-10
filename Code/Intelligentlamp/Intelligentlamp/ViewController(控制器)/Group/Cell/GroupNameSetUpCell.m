//
//  GroupNameSetUpCell.m
//  Intelligentlamp
//
//  Created by L on 16/8/20.
//  Copyright © 2016年 L. All rights reserved.
//
#define AllBulbTitleColor HEXCOLOR(0x8c8c8e)
#define AllBulbDescribeColor HEXCOLOR(0x8c8c8e)
#define AllBulbLineColor HEXCOLOR(0x19181b)
#define AllCellBgColor RGB(28,27,31)

#import "GroupNameSetUpCell.h"


@implementation GroupNameSetUpCell

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
    
    self.geoupNameLab = [[UILabel alloc]init];
    self.geoupNameLab.textColor =AllBulbTitleColor;
    self.geoupNameLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.geoupNameLab];
    [self.geoupNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
}
- (void)setTitle:(NSString *)title{
    _title = title;
    self.geoupNameLab.text = title;
}


@end
