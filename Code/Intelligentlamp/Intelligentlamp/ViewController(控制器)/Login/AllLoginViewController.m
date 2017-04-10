//
//  AllLoginViewController.m
//  Intelligentlamp
//
//  Created by L on 16/8/21.
//  Copyright © 2016年 L. All rights reserved.
//
#define GrayLine                           RGB(181,181,181)
#define RedIcon                            RGB(190,0,8)
#define PlaceHolderColor                   RGB(186,186,186)//13号

#define ForgetBtnTitle      @"忘记了"
#define PhoneTitle          @"请输入你的手机号码"
#define PwdTitle            @"请输入你的密码"

#define PhoneError          @"手机号码格式错误"
#define PwdError            @"密码格式错误"

#import "AllLoginViewController.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "UITextField+Validation.h"
#import "ResetPasswordViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <ShareSDKExtension/SSEBaseUser.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <SMS_SDK/SMSSDK.h>
#import <CommonCrypto/CommonDigest.h>
#import "RegisteredViewController.h"

//SMSSDK官网公共key


@interface AllLoginViewController()<UITextFieldDelegate>
@property ( nonatomic , strong ) UITextField                *phoneTxtField;/*帐号*/
@property ( nonatomic , strong ) UITextField                *pwdTxtField;/*密码*/
@property ( nonatomic , strong ) UIView                     *phoneBgImgView;/*帐号输入的容器*/
@property ( nonatomic , strong ) UIView                     *pwdBgImgView;/*密码输入的容器*/
@property ( nonatomic , strong ) UIButton                   *loginBtn;/*登录*/
@property ( nonatomic , strong ) UIButton                   *security;/*密码显示和关闭*/
@property ( nonatomic , strong ) UIButton                   *WeiXin;/*微信*/
@property ( nonatomic , strong ) UIButton                   *WeiBo;/*微博*/
@property ( nonatomic , strong ) UIButton                   *QQ;/*QQ*/
@property ( nonatomic , strong ) UIButton                   *noAccount;/*没有账号*/
@property (nonatomic, strong   ) IQKeyboardReturnKeyHandler *returnKeyHandler;/*键盘回调事件管理*/

@end
@implementation AllLoginViewController

#pragma -mark ViewController 生命周期函数

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
     [LXNetworking startMonitoring];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    [self setTitleViewWithStr:@"登录"];
    [self setTitleViewWithStr:NSLocalizedString(@"login", nil)];
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
//    _phoneBgImgView.userInteractionEnabled           = YES;
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
    _pwdTxtField.attributedPlaceholder               = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"EnterPWD", nil) attributes:@{NSForegroundColorAttributeName:AllLampTitleColor}];
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
    _phoneTxtField                                   = [[UITextField alloc] init];
    _phoneTxtField.keyboardType                      = UIKeyboardTypeNumberPad;
    [_phoneTxtField setValidationType:VALIDATION_TYPE_MOBILE_PHONE_VALIDATED];
    _phoneTxtField.delegate                          = self;
    _phoneTxtField.userInteractionEnabled            = YES;
    _phoneTxtField.leftViewMode                      = UITextFieldViewModeAlways;
    _phoneTxtField.contentVerticalAlignment          = UIControlContentVerticalAlignmentCenter;
    _phoneTxtField.tintColor                         = AllLampTitleColor;
    _phoneTxtField.attributedPlaceholder             = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"MobileNum", nil) attributes:@{NSForegroundColorAttributeName:AllLampTitleColor}];
    _phoneTxtField.font                              = [UIFont systemFontOfSize:13];
    _phoneTxtField.textColor = AllLampTitleColor;
//    _phoneTxtField.text = getUserPhone() != nil ? getUserPhone() :@"";
    
    //输入电话框边上的图片 UIImageView
    UIImageView *phoneLeftView                       = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 1)];
    phoneLeftView.contentMode                        = UIViewContentModeScaleAspectFit;
    _phoneTxtField.leftView                          = phoneLeftView;
//    phoneLeftView.image                              = [@"login_img_phone" getLoginBundleImage];
    [_pwdBgImgView addSubview:_phoneTxtField];
    [_phoneBgImgView addSubview:_phoneTxtField];
    [_phoneTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.centerY.equalTo(self.phoneBgImgView.mas_centerY);
        make.height.equalTo(@40);
        make.trailing.mas_equalTo(-10);
    }];
    
    //隐藏显示密码 UIButton
    _security                                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_security];
    [_security addTarget:self action:@selector(clickSecurityBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_security setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
    _security.titleLabel.font = [UIFont systemFontOfSize:13];
    [_security setTitle:NSLocalizedString(@"ForgotPWD", nil) forState:UIControlStateNormal];
    [_security mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_pwdBgImgView.mas_right);
        make.top.equalTo(_pwdBgImgView.mas_bottom).offset(15);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(150);
    }];
    
    
    //登录按钮 UIButton
    _loginBtn                                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    _loginBtn.titleLabel.font                        = [UIFont systemFontOfSize:15];
    [_loginBtn setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
//    _loginBtn.backgroundColor                        = RedIcon;
    [_loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
//    _loginBtn.layer.cornerRadius                     = 2;
    [self.view addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_pwdBgImgView.mas_right);
        make.top.equalTo(_security.mas_bottom).offset(15);
        make.height.mas_equalTo(54);
        make.left.equalTo(self.view.mas_left).offset(20);
    }];
    
    
    //键盘管理类(代理回调设定) IQKeyboardReturnKeyHandler
    self.returnKeyHandler                            = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.delegate                   = (id<UITextFieldDelegate,UITextViewDelegate>)self;
    
    UILabel *nameLabel = [[UILabel alloc]init];
    [self.view addSubview:nameLabel];
    nameLabel.text = NSLocalizedString(@"ThirdLogin", nil);
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = AllLampTitleColor;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.width.mas_equalTo(ScreenWidth);
        make.top.mas_equalTo(_loginBtn.mas_bottom).offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@30);
    }];
    
//    _WeiBo                                        = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:_WeiBo];
//    [_WeiBo addTarget:self action:@selector(WeiBoLogin) forControlEvents:UIControlEventTouchUpInside];
//    [_WeiBo setImage:[UIImage imageNamed:@"微博"] forState:UIControlStateNormal];
//    [_WeiBo setImage:[UIImage imageNamed:@"微博"] forState:UIControlStateHighlighted];
//    [_WeiBo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(55);
//        make.height.mas_equalTo(55);
//        make.top.mas_equalTo(nameLabel.mas_bottom).offset(20);
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//    }];

    
    _WeiXin                                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_WeiXin];
    if (![WXApi isWXAppInstalled]) {
        _WeiXin.hidden = YES;
    }else{
        _WeiXin.hidden = NO;
    }
    
    [_WeiXin addTarget:self action:@selector(WeiXinLogin) forControlEvents:UIControlEventTouchUpInside];
    [_WeiXin setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    [_WeiXin setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateHighlighted];
    [_WeiXin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(55);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(20);
//        make.right.mas_equalTo(_WeiBo.mas_left).offset(-35);
        make.centerX.mas_equalTo(nameLabel);
    }];
    
//    _QQ                                        = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:_QQ];
//    [_QQ addTarget:self action:@selector(QQLogin) forControlEvents:UIControlEventTouchUpInside];
//    [_QQ setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
//    [_QQ setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateHighlighted];
//    [_QQ mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(55);
//        make.height.mas_equalTo(55);
//        make.top.mas_equalTo(nameLabel.mas_bottom).offset(20);
//        make.left.mas_equalTo(_WeiBo.mas_right).offset(35);
//    }];
    
    //
    _noAccount                                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_noAccount];
    _noAccount.titleLabel.font = [UIFont systemFontOfSize:13];
    [_noAccount setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [_noAccount setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
    [_noAccount addTarget:self action:@selector(NoAccountLogin) forControlEvents:UIControlEventTouchUpInside];
    [_noAccount setTitle:NSLocalizedString(@"NoAccount", nil) forState:UIControlStateNormal];
    [_noAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth - 40);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@54);
    }];
}

#pragma －mark UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _phoneTxtField) {
        [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 140;
        _phoneBgImgView.layer.borderColor                = AllLampTitleColor.CGColor;
        _pwdBgImgView.layer.borderColor                  = GrayLine.CGColor;
    }
    else
    {
        [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 70;
        _phoneBgImgView.layer.borderColor                = GrayLine.CGColor;
        _pwdBgImgView.layer.borderColor                  = AllLampTitleColor.CGColor;
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    _phoneBgImgView.layer.borderColor                = GrayLine.CGColor;
    _pwdBgImgView.layer.borderColor                  = GrayLine.CGColor;
    return YES;
}

#pragma -mark UIButton点击事件

- (void)clickLoginBtn{
    NSLog(@"登录");
   
    
    if (_phoneTxtField.text.length <= 0||[_phoneTxtField.text isEqualToString:@""]) {
        [self showRemendWarningView:NSLocalizedString(@"PleaseEnterAccount", nil) withBlock:nil];
        return;
    }
    if (_pwdTxtField.text.length <=0 || [_pwdTxtField.text isEqualToString:@""]) {
        [self showRemendWarningView:NSLocalizedString(@"PleaseEnterPW", nil) withBlock:nil];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:@"1" forKey:@"userSource"];
    [dic setValue:_phoneTxtField.text forKey:@"loginName"];
    [dic setValue:[self md5:_pwdTxtField.text] forKey:@"password"];
    [dic setValue:@"2" forKey:@"platform"];
    
    
    if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
        [self showRemendWarningView:NSLocalizedString(@"NoInternet", nil) withBlock:nil];
        
    }else{
    
//    [self showNetWorkView];
    
    [LXNetworking postWithUrl:User_Login params:dic success:^(id response) {
        [self hideNetWorkView];
        
        setUserId(response[@"userId"]);
        setUserToken(response[@"token"]);
        
        NSNotification *notice = [NSNotification notificationWithName:@"NoticeLoginUserInfoRefresh" object:nil];
         [[NSNotificationCenter defaultCenter]postNotification:notice];

        [self showRemendSuccessView:NSLocalizedString(@"LoginSuccess", nil) withBlock:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } fail:^(NSError *error) {
        
        [self showRemendWarningView:NSLocalizedString(@"LoginFail", nil) withBlock:nil];
//        [self hideRemendView];
        
    } showHUD:nil];
    
    }



}
- (void)WeiBoLogin{
//    
//        [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeSinaWeibo onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
//            
//        } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
//            
//        }];
    [self showRemendWarningView:@"暂未开放此功能" withBlock:nil];
   
    NSLog(@"微博登录");
}
- (void)WeiXinLogin{
    
    if (![WXApi isWXAppInstalled]) {
        [self showRemendWarningView:@"未安装微信客户端" withBlock:nil];
    }
    else{
        [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeWechat onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
            
            //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
            //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
            associateHandler (user.uid, user, user);
            
        } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
            
            
            if (state == SSDKResponseStateSuccess) {
                
                SSEBaseUser *currentUser = [SSEThirdPartyLoginHelper currentUser];
                NSDictionary *curdic = [currentUser socialUsers];
                SSDKUser *curuser = [curdic objectForKey:[curdic.allKeys objectAtIndex:0]];
                NSLog(@"所有的值===%@",curuser.rawData);
                
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:@"1.0.0" forKey:@"version"];
                [dic setValue:@"5" forKey:@"userSource"];
                [dic setValue:curuser.rawData[@"unionid"] forKey:@"loginName"];
                [dic setValue:@"2" forKey:@"platform"];
                [dic setValue:@"2" forKey:@"nickname"];
                [dic setValue:@"2" forKey:@"headImgURL"];
                
                
                if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
                    [self showRemendWarningView:@"没有网络" withBlock:nil];
                    
                }else{
                    
//                    [self showNetWorkView];
                    
                    [LXNetworking postWithUrl:User_Login params:dic success:^(id response) {
                        [self hideNetWorkView];
                        
                        setUserId(response[@"userId"]);
                        setUserToken(response[@"token"]);
                        
                        NSNotification *notice = [NSNotification notificationWithName:@"NoticeLoginUserInfoRefresh" object:nil];
                        [[NSNotificationCenter defaultCenter]postNotification:notice];
                        
                        [self showRemendSuccessView:@"登陆成功" withBlock:nil];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                    } fail:^(NSError *error) {
                        
                        [self showRemendWarningView:@"登录失败" withBlock:nil];
                        
                        
                    } showHUD:nil];
                    
                }

                
            }else if (state == SSDKResponseStateCancel){
                [self showRemendWarningView:@"取消微信登录" withBlock:nil];
                
            }else if (state == SSDKResponseStateFail){
                
                [self showRemendWarningView:@"微信登录失败" withBlock:nil];
            }
        }];
        
    }
    NSLog(@"微信登录");
}
- (void)QQLogin{
    
    if (![QQApiInterface isQQInstalled]) {
        [self showRemendWarningView:@"未安装QQ客户端" withBlock:nil];
    }
    else{
       
        [self showRemendWarningView:@"暂未开放此功能" withBlock:nil];
//    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeQQ onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
//        
//    } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
//        if (state == SSDKResponseStateSuccess) {
//            
//            
//        }else if (state == SSDKResponseStateCancel){
//            
//        }else if (state == SSDKResponseStateFail){
//            
//        }
//    }];
    
}
    
}
- (void)NoAccountLogin{
    
    RegisteredViewController *vc = [[RegisteredViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)clickSecurityBtn:(UIButton *)btn
{
    ResetPasswordViewController *vc = [[ResetPasswordViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *) md5:(NSString *) str
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
