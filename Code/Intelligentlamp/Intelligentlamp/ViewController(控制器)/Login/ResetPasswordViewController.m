//
//  ResetPasswordViewController.m
//  Intelligentlamp
//
//  Created by L on 16/8/22.
//  Copyright © 2016年 L. All rights reserved.
//
#define GrayLine                           RGB(181,181,181)
#define RedIcon                            RGB(190,0,8)
#define PlaceHolderColor                   RGB(186,186,186)//13号

#define ForgetBtnTitle      @"忘记了"
#define PhoneTitle          @"请输入注册邮箱或者手机号码"
#define PwdTitle            @"请输入新密码"
#define CodeTitle            @"输入验证码"

#define PhoneError          @"手机号码格式错误"
#define PwdError            @"密码格式错误"

#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "UITextField+Validation.h"
#import "ResetPasswordViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <CommonCrypto/CommonDigest.h>

@interface ResetPasswordViewController()<UITextFieldDelegate>
@property ( nonatomic , strong ) UITextField                *phoneTxtField;/*帐号*/
@property ( nonatomic , strong ) UITextField                *pwdTxtField;/*密码*/
@property ( nonatomic , strong ) UIView                     *phoneBgImgView;/*帐号输入的容器*/
@property ( nonatomic , strong ) UIView                     *pwdBgImgView;/*密码输入的容器*/
@property ( nonatomic , strong ) UITextField                *codeTxtField;/*验证码*/
@property ( nonatomic , strong ) UIView                     *codeBgImgView;/*验证码的容器*/
@property ( nonatomic , strong ) UIButton                   *getCodeBtn;/*获取验证码按钮*/
@property ( nonatomic , strong ) UIButton                   *RegisteredBtn;/*登录*/
@property ( nonatomic , strong ) UIButton                   *haveAccountBtn;/*存在账号*/
@property ( nonatomic , strong ) UIButton                   *security;/*密码显示和关闭*/

@property (nonatomic, strong   ) IQKeyboardReturnKeyHandler *returnKeyHandler;/*键盘回调事件管理*/

@end

@implementation ResetPasswordViewController

#pragma -mark ViewController 生命周期函数

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithStr:NSLocalizedString(@"ResetPWD", nil)];
    [self layoutWithUI];
    
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)layoutWithUI{
    
    //最底层 UIImageView
    UIImageView *bgImgView                           = [[UIImageView alloc] init];
    [self.view addSubview:bgImgView];
    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //    bgImgView.image                                  = [@"common_img_bg" getLoginBundleImage];
    
    //输入电话背景 UIView
    _phoneBgImgView                                  = [[UIView alloc] init];
    _phoneBgImgView.userInteractionEnabled           = YES;
//    _phoneBgImgView.alpha                            = 0.6;
//    _phoneBgImgView.layer.cornerRadius               = 2;
//    _phoneBgImgView.layer.borderColor                = GrayLine.CGColor;
//    _phoneBgImgView.layer.borderWidth                = 1;
//    _phoneBgImgView.backgroundColor                  = [UIColor clearColor];
    [self.view addSubview:_phoneBgImgView];
    [_phoneBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(30);
        make.leading.mas_equalTo(self.view.mas_leading).offset(20);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-20);
        make.height.mas_equalTo(35);
    }];
    
    //输入电话框底图 UIImageView
    UIImageView *bgPhone                             = [[UIImageView alloc] init];
    [bgPhone setImage:[UIImage imageNamed:@"密码输入框"]];
    [_phoneBgImgView addSubview:bgPhone];
//    bgPhone.alpha                                    = 0.5;
    [bgPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_phoneBgImgView);
    }];
//    bgPhone.backgroundColor                          = [UIColor whiteColor];
//    bgPhone.layer.cornerRadius                       = 2;
    
    _phoneTxtField                                   = [[UITextField alloc] init];
    _phoneTxtField.keyboardType                      = UIKeyboardTypeNumberPad;
    [_phoneTxtField setValidationType:VALIDATION_TYPE_MOBILE_PHONE_VALIDATED];
    _phoneTxtField.delegate                          = self;
    _phoneTxtField.userInteractionEnabled            = YES;
    _phoneTxtField.leftViewMode                      = UITextFieldViewModeAlways;
    _phoneTxtField.contentVerticalAlignment          = UIControlContentVerticalAlignmentCenter;
    _phoneTxtField.tintColor                         = AllLampTitleColor;
    _phoneTxtField.attributedPlaceholder             = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"TheRegisterNum", nil) attributes:@{NSForegroundColorAttributeName:AllLampTitleColor}];
    _phoneTxtField.textColor = AllLampTitleColor;
    _phoneTxtField.font                              = [UIFont systemFontOfSize:13];
    //    _phoneTxtField.text = getUserPhone() != nil ? getUserPhone() :@"";
    
    //输入电话框边上的图片 UIImageView
    UIImageView *phoneLeftView                       = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 1)];
    phoneLeftView.contentMode                        = UIViewContentModeScaleAspectFit;
    _phoneTxtField.leftView                          = phoneLeftView;
    //    phoneLeftView.image                              = [@"login_img_phone" getLoginBundleImage];
    [_phoneBgImgView addSubview:_phoneTxtField];
    [_phoneTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.centerY.equalTo(self.phoneBgImgView.mas_centerY);
        make.height.equalTo(@40);
        make.trailing.mas_equalTo(-10);
    }];
    
    
    
    //输入密码背景 UIView
    _pwdBgImgView                                    = [[UIView alloc] init];
    _pwdBgImgView.userInteractionEnabled             = YES;
//    _pwdBgImgView.layer.cornerRadius                 = 2;
//    _pwdBgImgView.layer.borderColor                  = GrayLine.CGColor;
//    _pwdBgImgView.layer.borderWidth                  = 1;
//    _pwdBgImgView.alpha                            = 0.6;
//    _pwdBgImgView.backgroundColor                    = [UIColor clearColor];
    [self.view addSubview:_pwdBgImgView];
    [_pwdBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.equalTo(_phoneBgImgView.mas_bottom).offset(15);
        make.leading.mas_equalTo(self.view.mas_leading).offset(20);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-20);
        make.height.mas_equalTo(35);
    }];
    
    //输入密码框底图 UIImageView
    UIImageView *bgPwd                               = [[UIImageView alloc] init];
    [bgPwd setImage:[UIImage imageNamed:@"密码输入框"]];
    [_pwdBgImgView addSubview:bgPwd];
//    bgPwd.alpha                                      = 0.5;
    [bgPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_pwdBgImgView);
    }];
//    bgPwd.backgroundColor                            = [UIColor whiteColor];
//    bgPwd.layer.cornerRadius                         = 2;
    
    //输入密码框 UITextField
    _pwdTxtField                                     = [[UITextField alloc] init];
    [_pwdTxtField setValidationType:VALIDATION_TYPE_PASSWORD_VALIDATED];
    _pwdTxtField.userInteractionEnabled              = YES;
    _pwdTxtField.delegate                            = self;
    _pwdTxtField.leftViewMode                        = UITextFieldViewModeAlways;
    _pwdTxtField.contentVerticalAlignment            = UIControlContentVerticalAlignmentCenter;
    _pwdTxtField.tintColor                           = AllLampTitleColor;
    _pwdTxtField.secureTextEntry                     = YES;
    _pwdTxtField.keyboardType                      = UIKeyboardTypeNamePhonePad;
    _pwdTxtField.attributedPlaceholder               = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"NewPassword", nil) attributes:@{NSForegroundColorAttributeName:AllLampTitleColor}];
    _pwdTxtField.textColor = AllLampTitleColor;
    _pwdTxtField.font                                = [UIFont systemFontOfSize:13];
    
    //输入密码框边上的图片 UIImageView
    UIImageView *pwdLeftView                         = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 1)];
    pwdLeftView.contentMode                          = UIViewContentModeScaleAspectFit;
    _pwdTxtField.leftView                            = pwdLeftView;
    //    pwdLeftView.image                                = [@"login_img_pwd" getLoginBundleImage];
    [_pwdBgImgView addSubview:_pwdTxtField];
    [_pwdTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.centerY.equalTo(self.pwdBgImgView.mas_centerY);
        make.height.equalTo(@40);
        make.trailing.mas_equalTo(-10);
    }];
    
    
    //输入验证码背景 UIView
    _codeBgImgView                                  = [[UIView alloc] init];
    _codeBgImgView.userInteractionEnabled           = YES;
//    _codeBgImgView.alpha                            = 0.6;
//    _codeBgImgView.layer.cornerRadius               = 2;
//    _codeBgImgView.layer.borderColor                = GrayLine.CGColor;
//    _codeBgImgView.layer.borderWidth                = 1;
//    _codeBgImgView.backgroundColor                  = [UIColor clearColor];
    [self.view addSubview:_codeBgImgView];
    [_codeBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_pwdBgImgView.mas_bottom).offset(15);
        make.left.mas_equalTo(_pwdBgImgView.mas_left);
        make.width.mas_equalTo((ScreenWidth - 50)/2);
        make.height.mas_equalTo(35);
    }];
    
    
    //输入验证码框底图 UIImageView
    UIImageView *bgcode                             = [[UIImageView alloc] init];
    [bgcode setImage:[UIImage imageNamed:@"密码输入框"]];
    [_codeBgImgView addSubview:bgcode];
//    bgcode.alpha                                    = 0.5;
    [bgcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_codeBgImgView);
    }];
//    bgcode.backgroundColor                          = [UIColor whiteColor];
//    bgcode.layer.cornerRadius                       = 2;
    
    _codeTxtField                                   = [[UITextField alloc] init];
    _codeTxtField.keyboardType                      = UIKeyboardTypeNumberPad;
    [_codeTxtField setValidationType:VALIDATION_TYPE_NUM_VALIDATED];
    _codeTxtField.delegate                          = self;
    _codeTxtField.userInteractionEnabled            = YES;
    _codeTxtField.leftViewMode                      = UITextFieldViewModeAlways;
    _codeTxtField.contentVerticalAlignment          = UIControlContentVerticalAlignmentCenter;
    _codeTxtField.tintColor                         = AllLampTitleColor;
    _codeTxtField.attributedPlaceholder             = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"InputCode", nil) attributes:@{NSForegroundColorAttributeName:AllLampTitleColor}];
    _codeTxtField.textColor =AllLampTitleColor;
    _codeTxtField.font                              = [UIFont systemFontOfSize:13];
    //    _codeTxtField.text = getUserPhone() != nil ? getUserPhone() :@"";
    
    
    //    //输入验证码框边上的图片 UIImageView
    UIImageView *codeLeftView                         = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 1)];
    codeLeftView.contentMode                          = UIViewContentModeScaleAspectFit;
    _codeTxtField.leftView                            = codeLeftView;
    //    pwdLeftView.image                                = [@"login_img_pwd" getLoginBundleImage];
    [_codeBgImgView addSubview:_codeTxtField];
    [_codeTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.centerY.equalTo(_codeBgImgView.mas_centerY);
        make.height.equalTo(@40);
        make.trailing.mas_equalTo(-10);
    }];
    
    //获取验证码按钮 UIButton
    _getCodeBtn                                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getCodeBtn setTitle:NSLocalizedString(@"GetCode", nil) forState:UIControlStateNormal];
    [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    _getCodeBtn.titleLabel.font                        = [UIFont systemFontOfSize:13];
    [_getCodeBtn setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
//    _getCodeBtn.backgroundColor                        = RedIcon;
    [_getCodeBtn addTarget:self action:@selector(clickGetCodeBtn) forControlEvents:UIControlEventTouchUpInside];
//    _getCodeBtn.layer.cornerRadius                     = 2;
    [self.view addSubview:_getCodeBtn];
    [_getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_pwdBgImgView.mas_bottom).offset(15);
        make.left.mas_equalTo(_codeBgImgView.mas_right).offset(10);
        make.width.mas_equalTo((ScreenWidth - 50)/2);
        make.height.mas_equalTo(38);
    }];
    
    //注册按钮 UIButton
    _RegisteredBtn                                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [_RegisteredBtn setTitle:NSLocalizedString(@"ResetPWD", nil) forState:UIControlStateNormal];
    [_RegisteredBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    _RegisteredBtn.titleLabel.font                        = [UIFont systemFontOfSize:15];
    [_RegisteredBtn setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
//    _RegisteredBtn.backgroundColor                        = RedIcon;
    [_RegisteredBtn addTarget:self action:@selector(clickRegisteredBtn) forControlEvents:UIControlEventTouchUpInside];
//    _RegisteredBtn.layer.cornerRadius                     = 2;
    [self.view addSubview:_RegisteredBtn];
    [_RegisteredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_pwdBgImgView.mas_right);
        make.top.equalTo(_codeBgImgView.mas_bottom).offset(50);
        make.height.mas_equalTo(54);
        make.left.equalTo(self.view.mas_left).offset(20);
    }];
    
    
    //隐藏显示密码 UIButton
    _security                                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pwdBgImgView addSubview:_security];
    [_security addTarget:self action:@selector(clickSecurityBtn:) forControlEvents:UIControlEventTouchUpInside];
    _security.tag = 0;
    [_security setImage:[UIImage imageNamed:@"login_img_biyan"] forState:UIControlStateNormal];
    [_security mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_pwdBgImgView.mas_right);
        make.top.equalTo(_pwdBgImgView.mas_top);
        make.bottom.equalTo(_pwdBgImgView.mas_bottom);
        make.width.mas_equalTo(_pwdBgImgView.mas_height);
    }];
    
    _haveAccountBtn                                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_haveAccountBtn];
    _haveAccountBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_haveAccountBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [_haveAccountBtn setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
    [_haveAccountBtn addTarget:self action:@selector(haveAccountLogin) forControlEvents:UIControlEventTouchUpInside];
    [_haveAccountBtn setTitle:NSLocalizedString(@"ExistAccount", nil) forState:UIControlStateNormal];
    [_haveAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth - 40);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@54);
    }];
    
    
    //键盘管理类(代理回调设定) IQKeyboardReturnKeyHandler
    self.returnKeyHandler                            = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.delegate                   = (id<UITextFieldDelegate,UITextViewDelegate>)self;
    
    
    
}

#pragma －mark UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _phoneTxtField) {
        [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 140;
        _phoneBgImgView.layer.borderColor                = AllLampTitleColor.CGColor;
        _pwdBgImgView.layer.borderColor                  = GrayLine.CGColor;
        _codeBgImgView.layer.borderColor                  = GrayLine.CGColor;
        
    }
    else if(textField == _pwdTxtField)
    {
        [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 70;
        _phoneBgImgView.layer.borderColor                = GrayLine.CGColor;
        _pwdBgImgView.layer.borderColor                  = AllLampTitleColor.CGColor;
        _codeBgImgView.layer.borderColor                  = GrayLine.CGColor;
        
    }else{
        
        [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 70;
        _phoneBgImgView.layer.borderColor                = GrayLine.CGColor;
        _pwdBgImgView.layer.borderColor                  = GrayLine.CGColor;
        _codeBgImgView.layer.borderColor                  = AllLampTitleColor.CGColor;
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    _phoneBgImgView.layer.borderColor                = GrayLine.CGColor;
    _pwdBgImgView.layer.borderColor                  = GrayLine.CGColor;
    return YES;
}

#pragma -mark UIButton点击事件
- (void)haveAccountLogin{

    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)clickGetCodeBtn{
    
    /**
     *  @from                    v1.1.1
     *  @brief                   获取验证码(Get verification code)
     *
     *  @param method            获取验证码的方法(The method of getting verificationCode)
     *  @param phoneNumber       电话号码(The phone number)
     *  @param zone              区域号，不要加"+"号(Area code)
     *  @param customIdentifier  自定义短信模板标识 该标识需从官网http://www.mob.com上申请，审核通过后获得。(Custom model of SMS.  The identifier can get it  from http://www.mob.com  when the application had approved)
     *  @param result            请求结果回调(Results of the request)
     */
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneTxtField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        
        if (!error) {
            [self showRemendSuccessView:@"验证码已发送" withBlock:nil];
            NSLog(@"获取验证码成功");
        }else{
            [self showRemendWarningView:@"验证码获取失败" withBlock:nil];
            NSLog(@"获取失败");
        }
    }];
    
    
}
- (void)clickRegisteredBtn{
    NSLog(@"重置密码");
    [SMSSDK commitVerificationCode:_codeTxtField.text phoneNumber:_phoneTxtField.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        if (!error) {
            NSLog(@"验证成功");
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"1.0.0" forKey:@"version"];
            [dic setValue:@"1" forKey:@"userSource"];
            [dic setValue:_phoneTxtField.text forKey:@"loginName"];
            [dic setValue:[self md5:_pwdTxtField.text] forKey:@"password"];
            [dic setValue:@"2" forKey:@"operateType"];
            [dic setValue:@"com.gooorun.smartlamp" forKey:@"appPackageName"];
            [dic setValue:_codeTxtField.text forKey:@"captcha"];
            
            [self showNetWorkView];
            
            [LXNetworking postWithUrl:User_Regist params:dic success:^(id response) {
                NSLog(@"重置密码成功");
                
                
                [self hideNetWorkView];
                
            } fail:^(NSError *error) {
                
                
                [self hideNetWorkView];
            } showHUD:nil];
            
            
            
        }
        else
        {
            [self showRemendWarningView:@"验证码输入错误" withBlock:nil];
            return ;
            
        }
    }];
    
//    [SMSSDK commitVerificationCode:_codeTxtField.text phoneNumber:_phoneTxtField.text zone:@"86" result:^(NSError *error) {
//        
//        if (!error) {
//            NSLog(@"验证成功");
//            
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            [dic setValue:@"1.0.0" forKey:@"version"];
//            [dic setValue:@"1" forKey:@"userSource"];
//            [dic setValue:_phoneTxtField.text forKey:@"loginName"];
//            [dic setValue:[self md5:_pwdTxtField.text] forKey:@"password"];
//            [dic setValue:@"2" forKey:@"operateType"];
//            [dic setValue:@"com.gooorun.smartlamp" forKey:@"appPackageName"];
//            [dic setValue:_codeTxtField.text forKey:@"captcha"];
//            
//            [self showNetWorkView];
//            
//            [LXNetworking postWithUrl:User_Regist params:dic success:^(id response) {
//                NSLog(@"重置密码成功");
//                [self hideNetWorkView];
//                [self showRemendSuccessView:@"重置密码成功" withBlock:nil];
//                
//                
//                
//            } fail:^(NSError *error) {
//                
//                [self showRemendWarningView:@"重置密码失败" withBlock:nil];
//                [self hideNetWorkView];
//            } showHUD:nil];
//            
//            
//            
//        }
//        else
//        {
//            [self showRemendWarningView:@"验证码输入错误" withBlock:nil];
//            return ;
//            
//        }
//    }];
    

}

-(void)clickSecurityBtn:(UIButton *)btn
{
    if (btn.tag == 1) {
        btn.tag = 0;
        [btn setImage:[UIImage imageNamed:@"login_img_biyan"] forState:UIControlStateNormal];
        _pwdTxtField.secureTextEntry = YES;
    }
    else
    {
        btn.tag = 1;
        [btn setImage:[UIImage imageNamed:@"login_img_zhengyan"] forState:UIControlStateNormal];
        _pwdTxtField.secureTextEntry = NO;
    }
}

- (NSString *)md5:(NSString *) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end


