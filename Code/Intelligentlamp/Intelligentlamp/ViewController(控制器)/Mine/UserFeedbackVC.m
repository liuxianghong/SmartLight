//
//  UserFeedbackVC.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#define GrayLine                           RGB(181,181,181)
#define RedIcon                            RGB(190,0,8)
#define TitleColor HEXCOLOR(0x4a4a4a)
#import "UserFeedbackVC.h"

@interface UserFeedbackVC()<UITextViewDelegate>

@property (nonatomic ,strong) UITextView *textView;
@property (nonatomic ,strong) UILabel *placeholder;
@property (nonatomic ,strong) UIButton *submitBtn;

@end

@implementation UserFeedbackVC

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
    
    [self setTitleViewWithStr:@"用户反馈"];
    
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self layoutUI];
    
}

- (void)layoutUI{
    
    _textView = [[UITextView alloc]init];
    _textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"feedback_enter_frame"]];
    _textView.delegate = self;
    _textView.textColor = TitleColor;
    [self.view addSubview:_textView];
    _textView.font = [UIFont systemFontOfSize:13];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(15);
        make.leading.mas_equalTo(self.view.mas_leading).offset(15);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-15);
        make.height.mas_equalTo(180);
    }];
    
    _placeholder = [[UILabel alloc]init];
    _placeholder.textColor = TitleColor;
    _placeholder.font = [UIFont systemFontOfSize:13];
    _placeholder.text = @"请输入留言";
    [_textView addSubview:_placeholder];
    [_placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(15);
        make.leading.mas_equalTo(self.view.mas_leading).offset(20);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-15);
        make.height.mas_equalTo(35);
    }];
    
    _submitBtn                                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [_submitBtn setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
    _submitBtn.titleLabel.font                        = [UIFont systemFontOfSize:15];
    [_submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.layer.cornerRadius                     = 2;
    [self.view addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_textView.mas_right);
        make.top.equalTo(_textView.mas_bottom).offset(20);
        make.height.mas_equalTo(106/1334.0*ScreenHeight);
        make.left.equalTo(_textView.mas_left);
    }];
    
}

- (void)clickSubmitBtn{
    
    if ([_textView.text isEqualToString:@""]||_textView.text.length <= 0) {
        [self showRemendWarningView:@"请输入你的意见！" withBlock:nil];
        return;
    }
    
        
        NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
        [dic setValue:@"1.0.0" forKey:@"version"];
        [dic setValue:getUserId() forKey:@"userId"];
        [dic setValue:getUserToken() forKey:@"token"];
        [dic setValue:@"" forKey:@"contact"];
        [dic setValue:_textView.text forKey:@"opinion"];

        [self showNetWorkView];
        [LXNetworking postWithUrl:User_Feedback params:dic success:^(id response) {
            [self hideNetWorkView];
            if (response[@"retCode"] == 0 ||[ response[@"retCode"] isEqualToString:@"0"]) {
                
                [self showRemendSuccessView:response[@"retMsg"] withBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            
        } fail:^(NSError *error) {
            
            [self hideNetWorkView];

        } showHUD:nil];

}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    _placeholder.hidden = YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (comcatstr.length <= 0 ) {
        _placeholder.hidden =NO;
    }else{
        _placeholder.hidden = YES;
    }
    
    return YES;
}

@end
