//
//  UserNameChangeViewController.m
//  Intelligentlamp
//
//  Created by L on 16/9/19.
//  Copyright © 2016年 L. All rights reserved.
//
#define AllBulbTitleColor HEXCOLOR(0x8c8c8e)
#define AllBulbLineColor HEXCOLOR(0x19181b)

#import "UserNameChangeViewController.h"

@interface UserNameChangeViewController()<UITextFieldDelegate>

@property (nonatomic ,strong) UITextField *textFild;
@end

@implementation UserNameChangeViewController


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
    
    [self setTitleViewWithStr:self.titleStr];
    
    [self layoutUI];
    
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{

        if ([_textFild.text isEqualToString:self.content]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self changeUserName];
        }
        
    }];
    
    
}
- (void)changeUserName{
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:_textFild.text forKey:@"nickname"];

    
        [self showNetWorkView];
        
        
        [LXNetworking postWithUrl:User_UpdateUserInfo params:dic success:^(id response) {
            [self hideNetWorkView];
            [self showRemendSuccessView:response[@"retMsg"] withBlock:nil];
            
            if (self.changeContentBlock) {
                self.changeContentBlock(_textFild.text);
            }

            [self.navigationController popViewControllerAnimated:YES];
        } fail:^(NSError *error) {
            [self hideNetWorkView];
            [self showRemendWarningView:@"修改失败" withBlock:nil];
            
        } showHUD:nil];

}

- (void)layoutUI{
    
    _textFild = [[UITextField alloc]init];
    _textFild.text = self.content;
//    _textFild.backgroundColor = AllCellBgColor;
    _textFild.background = [UIImage imageNamed:@"enter_frame_bg"];
    _textFild.font = [UIFont systemFontOfSize:15];
    _textFild.textColor = AllBulbTitleColor;
    [self.view addSubview:_textFild];
    
    [_textFild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(51);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(self.view.mas_width);
        
    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = AllBulbLineColor;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textFild.mas_bottom).offset(1);
        make.width.mas_equalTo(_textFild.mas_width);
        make.height.mas_equalTo(1);
    }];
    
    
}

@end
