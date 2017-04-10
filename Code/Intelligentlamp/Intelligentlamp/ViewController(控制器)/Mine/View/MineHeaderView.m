//
//  MineHeaderView.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "MineHeaderView.h"
#import "UserModel.h"

@implementation MineHeaderView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = AllCellBgColor;
    }
    return self;
}

- (void)layoutHeaderView{
    self.bgView = [[UIView alloc]init];
//    self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mine_bg"]];
    _bgView.backgroundColor = AllCellBgColor;
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.iconImg = [[UIImageView alloc]init];
    self.iconImg.userInteractionEnabled = YES;
    self.iconImg.layer.masksToBounds=YES;
    self.iconImg.layer.cornerRadius=45; //设置为图片宽度的一半出来为圆形
    self.iconImg.layer.borderWidth=1.0f; //边框宽度
    self.iconImg.layer.borderColor=[AllBgColor CGColor];//边框颜色
//    self.iconImg.image = [UIImage imageNamed:@"common_loading1"];
    [self.bgView addSubview:self.iconImg];
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    singleRecognizer.numberOfTapsRequired = 1;
    singleRecognizer.numberOfTouchesRequired = 1;
    [self.iconImg addGestureRecognizer:singleRecognizer];

    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@90);
        make.height.equalTo(@90);
        
    }];
    
    self.name = [[UILabel alloc]init];
    self.name.userInteractionEnabled = YES;
     UITapGestureRecognizer *Recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNameGesture)];
    Recognizer.numberOfTapsRequired = 1;
    Recognizer.numberOfTouchesRequired = 1;
    [self.name addGestureRecognizer:Recognizer];
//    self.name.text = @"这个是一个测试账号";
    self.name.textAlignment = NSTextAlignmentCenter;
    self.name.font = [UIFont systemFontOfSize:15];
    self.name.textColor = AllLampTitleColor;
    [self.bgView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.iconImg.mas_bottom).offset(5);
        make.centerX.equalTo(self);
        make.height.mas_greaterThanOrEqualTo(@30);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = AllLampLineColor;
    [self.bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
    }];
    
}

- (void)tapGesture{
    if (self.changeIconBlock) {
        self.changeIconBlock();
    }
}

- (void)tapNameGesture{
    if (self.changeNameBlock) {
        self.changeNameBlock();
    }
}
- (void)setModel:(UserModel *)model{
    _model = model;
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:model.userImg] placeholderImage:[UIImage imageNamed:@"my_user_avatar"]];
    _name.text = _model.userName;
}
@end
