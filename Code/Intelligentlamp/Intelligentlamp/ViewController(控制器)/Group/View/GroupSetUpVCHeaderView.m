//
//  GroupSetUpVCHeaderView.m
//  Intelligentlamp
//
//  Created by L on 16/8/20.
//  Copyright © 2016年 L. All rights reserved.
//
#define AllBulbLineColor HEXCOLOR(0x19181b)
#define AllCellBgColor RGB(28,27,31)
#import "GroupSetUpVCHeaderView.h"

@implementation GroupSetUpVCHeaderView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = AllCellBgColor;
    }
    return self;
}

- (void)layoutHeaderView{
    
    self.iconImg = [[UIImageView alloc]init];
    
    self.iconImg.layer.masksToBounds=YES;
    self.iconImg.layer.cornerRadius=45; //设置为图片宽度的一半出来为圆形
    self.iconImg.layer.borderWidth=1.0f; //边框宽度
//    self.iconImg.layer.borderColor=[[UIColor whiteColor] CGColor];//边框颜色
    
    self.iconImg.userInteractionEnabled = YES;
//    self.iconImg.image = [UIImage imageNamed:@"group_avatar@"];
    [self addSubview:self.iconImg];
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    singleRecognizer.numberOfTapsRequired = 1;
    singleRecognizer.numberOfTouchesRequired = 1;
    [self.iconImg addGestureRecognizer:singleRecognizer];
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@90);
        make.height.equalTo(@90);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        
    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = AllBulbLineColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(1);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    
}

- (void)tapGesture{
    if (self.changeIconBlock) {
        self.changeIconBlock();
    }
}

- (void)setIcon:(NSString *)icon{
    _icon = icon;
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:icon]];
}
@end

