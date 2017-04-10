//
//  AboutVC.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC()

@property (nonatomic ,strong) UIImageView *iconImg;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *describeLabel;

@end
@implementation AboutVC

#pragma -mark ViewController 生命周期函数

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setTitleViewWithStr:@"关于我们"];
    
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self layoutUI];
    
}

- (void)layoutUI{
    
    self.iconImg = [[UIImageView alloc]init];
    self.iconImg.userInteractionEnabled = YES;
    self.iconImg.image = [UIImage imageNamed:@"Icon-76"];
    [self.view addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(50);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"上海球际";
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = AllTitleColor;
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.iconImg.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(30);
        make.width.equalTo(self.view.mas_width);
    }];
    
    
    self.describeLabel = [[UILabel alloc]init];
    self.describeLabel.numberOfLines = 0;
    self.describeLabel.textAlignment = NSTextAlignmentCenter;
    self.describeLabel.text = @"V 1.0";
    self.describeLabel.font = [UIFont systemFontOfSize:15];
    self.describeLabel.textColor = AllTitleColor;
    [self.view addSubview:self.describeLabel];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(120);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_greaterThanOrEqualTo(30);
        make.width.equalTo(self.view.mas_width).offset(-50);
    }];
}
@end
