//
//  SystemUpdateVC.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#define RedIcon                            RGB(190,0,8)
#import "SystemUpdateVC.h"
#import "LampUpdateHubView.h"

@interface SystemUpdateVC()

@property (nonatomic ,strong) UIImageView *iconImg;
@property (nonatomic ,strong) UILabel *versionLabel;
@property (nonatomic ,strong) UILabel *describeLabel;
@property (nonatomic ,strong) UIButton *updateBtn;
@property (nonatomic ,strong) LampUpdateHubView *lampUpdataView;
@end

@implementation SystemUpdateVC

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
    
    [self setTitleViewWithStr:@"系统更新"];
    
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self layoutUI];
}

- (void)layoutUI{
    
        self.iconImg = [[UIImageView alloc]init];
        self.iconImg.userInteractionEnabled = YES;
        self.iconImg.image = [UIImage imageNamed:@"common_loading1"];
        [self.view addSubview:self.iconImg];
        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(30);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(@80);
            make.height.equalTo(@80);
            
        }];
        
        self.versionLabel = [[UILabel alloc]init];
        self.versionLabel.text = @"V1.0";
        self.versionLabel.textAlignment = NSTextAlignmentCenter;
        self.versionLabel.font = [UIFont systemFontOfSize:15];
        self.versionLabel.textColor = AllTitleColor;
        [self.view addSubview:self.versionLabel];
        [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.iconImg.mas_bottom).offset(15);
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.mas_equalTo(30);
            make.width.equalTo(self.view.mas_width);
        }];
        
        
        self.describeLabel = [[UILabel alloc]init];
        self.describeLabel.text = @"当前已是最新版本";
        self.describeLabel.textAlignment = NSTextAlignmentCenter;
        self.describeLabel.font = [UIFont systemFontOfSize:15];
        self.describeLabel.textColor = AllTitleColor;
        [self.view addSubview:self.describeLabel];
        [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(self.view.mas_centerY);
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.mas_equalTo(30);
            make.width.equalTo(self.view.mas_width).offset(-50);
        }];
    
    
    _updateBtn                                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [_updateBtn setTitle:@"检查更新" forState:UIControlStateNormal];
    _updateBtn.titleLabel.font                        = [UIFont systemFontOfSize:15];
    [_updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_updateBtn setBackgroundImage:[UIImage imageNamed:@"还没账号"] forState:UIControlStateNormal];
    [_updateBtn addTarget:self action:@selector(clickupdateBtn) forControlEvents:UIControlEventTouchUpInside];
    _updateBtn.layer.cornerRadius                     = 2;
    [self.view addSubview:_updateBtn];
    [_updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.height.mas_equalTo(106/1334.0*ScreenHeight);
        make.width.mas_equalTo(ScreenWidth - 80);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    
    _lampUpdataView = [[LampUpdateHubView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    _lampUpdataView.hidden = YES;
    _lampUpdataView.center = self.view.center;
    [self.view addSubview:_lampUpdataView];
    [_lampUpdataView showHub];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [_lampUpdataView dismissHub];
        _describeLabel.hidden = NO;
    });

}

- (void)clickupdateBtn{
    _lampUpdataView.hidden =NO;
    _describeLabel.hidden = YES;
}
@end
