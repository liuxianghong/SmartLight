//
//  SharedView.m
//  weixin
//
//  Created by L on 16/8/18.
//  Copyright © 2016年 L. All rights reserved.
//
//
#import "SharedView.h"
#import <WeiboSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXReminderView.h"
#import "UIView+CustomAnimation.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
//#import <ShareSDKExtension/SSEBaseUser.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>

#define AllLeftPadding 12
#define BtnBgHeight 104
#define CancelBtnHeight 42
#define BtnHeight 51
#define sharedURL   @"http://www.baidu.com"
#define sharedTitle @"蓝牙智能灯分享"
#define sharedContent @"蓝牙智能灯分享内容"
#define BlackTitle HEXCOLOR(0x4d4d4d)
#define BtnTitleFont [UIFont systemFontOfSize:12]
#define CancelTitleFont [UIFont systemFontOfSize:14]
#define LabelHeight 20
#define DefaultHeight 200

@interface SharedView()
@property (nonatomic , strong) UIButton *wxSessionBtn;
@property (nonatomic , strong) UIButton *wxTimeLineBtn;
@property (nonatomic , strong) UIButton *qqBtn;
@property (nonatomic , strong) UIButton *weiboBtn;
@property (nonatomic , strong) UIButton *cancelBtn;
@property (nonatomic , strong) UIImageView *btnBg;
@property (nonatomic , strong) UIButton *maskBtn;
@property (nonatomic , assign) CGFloat inDuration;
@end

@implementation SharedView

+ (SharedView *)shareInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance                         = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _btnBg = [[UIImageView alloc] init];
        _btnBg.userInteractionEnabled = YES;
        [self addSubview:_btnBg];
        [_btnBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self.mas_left).offset(AllLeftPadding);
            make.right.mas_equalTo(self.mas_right).offset(-AllLeftPadding);
            make.height.mas_equalTo(BtnBgHeight);
        }];
        _btnBg.backgroundColor = [UIColor whiteColor];
        _btnBg.layer.cornerRadius = 6;
        _btnBg.layer.masksToBounds = YES;
        
        [self.wxSessionBtn setBackgroundImage:[UIImage imageNamed:@"common_icon-weixin"] forState:UIControlStateNormal];
        [self.wxTimeLineBtn setBackgroundImage:[UIImage imageNamed:@"common_icon-pengyouquan"] forState:UIControlStateNormal];
        [self.qqBtn setBackgroundImage:[UIImage imageNamed:@"common_icon-QQ"] forState:UIControlStateNormal];
        [self.weiboBtn setBackgroundImage:[UIImage imageNamed:@"common_icon-weibo"] forState:UIControlStateNormal];
        
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    return self;
}

-(UIButton *)wxTimeLineBtn
{
    if (!_wxTimeLineBtn) {
        _wxTimeLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wxTimeLineBtn addTarget:self action:@selector(sendToPengYouQuanBtnPress) forControlEvents:UIControlEventTouchUpInside];
        _wxTimeLineBtn.layer.masksToBounds = YES;
        _wxTimeLineBtn.layer.cornerRadius = BtnHeight/2;
        [_btnBg addSubview:_wxTimeLineBtn];
        [_wxTimeLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_btnBg.mas_centerY).offset(-10);
            make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(4/5.0);
            make.width.mas_equalTo(BtnHeight);
            make.height.mas_equalTo(BtnHeight);
        }];
        UILabel *textLabel = [[UILabel alloc] init];
        [_btnBg addSubview:textLabel];
        textLabel.textColor = BlackTitle;
        textLabel.font = BtnTitleFont;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = @"朋友圈";
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_wxTimeLineBtn.mas_width);
            make.height.mas_equalTo(LabelHeight);
            make.top.mas_equalTo(_wxTimeLineBtn.mas_bottom).offset(5);
            make.centerX.mas_equalTo(_wxTimeLineBtn.mas_centerX);
        }];
    }
    return _wxTimeLineBtn;
}

-(UIButton *)wxSessionBtn
{
    if (!_wxSessionBtn) {
        _wxSessionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnBg addSubview:_wxSessionBtn];
        [_wxSessionBtn addTarget:self action:@selector(sendToFriendBtnPress) forControlEvents:UIControlEventTouchUpInside];
        _wxSessionBtn.layer.masksToBounds = YES;
        _wxSessionBtn.layer.cornerRadius = BtnHeight/2;
        [_wxSessionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_btnBg.mas_centerY).offset(-10);
            make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(2/5.0);
            make.width.mas_equalTo(BtnHeight);
            make.height.mas_equalTo(BtnHeight);
        }];
        UILabel *textLabel = [[UILabel alloc] init];
        [_btnBg addSubview:textLabel];
        textLabel.textColor = BlackTitle;
        textLabel.font = BtnTitleFont;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = @"微信好友";
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_wxSessionBtn.mas_width);
            make.height.mas_equalTo(LabelHeight);
            make.top.mas_equalTo(_wxSessionBtn.mas_bottom).offset(5);
            make.centerX.mas_equalTo(_wxSessionBtn.mas_centerX);
        }];
    }
    return _wxSessionBtn;
}

-(UIButton *)qqBtn
{
    if (!_qqBtn) {
        _qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnBg addSubview:_qqBtn];
        [_qqBtn addTarget:self action:@selector(sendToQQBtnPress) forControlEvents:UIControlEventTouchUpInside];
        _qqBtn.layer.masksToBounds = YES;
        _qqBtn.layer.cornerRadius = BtnHeight/2;
        [_qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_btnBg.mas_centerY).offset(-10);
            make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(6/5.0);
            make.width.mas_equalTo(BtnHeight);
            make.height.mas_equalTo(BtnHeight);
        }];
        UILabel *textLabel = [[UILabel alloc] init];
        [_btnBg addSubview:textLabel];
        textLabel.textColor = BlackTitle;
        textLabel.font = BtnTitleFont;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = @"qq";
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_qqBtn.mas_width);
            make.height.mas_equalTo(LabelHeight);
            make.top.mas_equalTo(_qqBtn.mas_bottom).offset(5);
            make.centerX.mas_equalTo(_qqBtn.mas_centerX);
        }];
    }
    return _qqBtn;
}

-(UIButton *)weiboBtn
{
    if (!_weiboBtn) {
        _weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnBg addSubview:_weiboBtn];
        [_weiboBtn addTarget:self action:@selector(sendToWeiboBtnPress) forControlEvents:UIControlEventTouchUpInside];
        _weiboBtn.layer.masksToBounds = YES;
        _weiboBtn.layer.cornerRadius = BtnHeight/2;
        [_weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_btnBg.mas_centerY).offset(-10);
            make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(8/5.0);
            make.width.mas_equalTo(BtnHeight);
            make.height.mas_equalTo(BtnHeight);
        }];
        UILabel *textLabel = [[UILabel alloc] init];
        [_btnBg addSubview:textLabel];
        textLabel.textColor = BlackTitle;
        textLabel.font = BtnTitleFont;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = @"微博";
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_weiboBtn.mas_width);
            make.height.mas_equalTo(LabelHeight);
            make.top.mas_equalTo(_weiboBtn.mas_bottom).offset(5);
            make.centerX.mas_equalTo(_weiboBtn.mas_centerX);
        }];
    }
    return _weiboBtn;
}

-(UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.titleLabel.font = CancelTitleFont;
        _cancelBtn.layer.cornerRadius = 4;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitleColor:BlackTitle forState:UIControlStateNormal];
        [self addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_btnBg.mas_bottom).offset(10);
            make.left.mas_equalTo(self.mas_left).offset(AllLeftPadding);
            make.right.mas_equalTo(self.mas_right).offset(-AllLeftPadding);
            make.height.mas_equalTo(CancelBtnHeight);
        }];
    }
    return _cancelBtn;
}

#pragma mark - 发送给朋友
- (void)sendToFriendBtnPress {
    
    if (![WXApi isWXAppInstalled]) {
        [SVProgressHUD showErrorWithStatus:@"未安装微信客户端!"];
        return;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray *imageArray = @[[UIImage imageNamed:@"common_loading"]];
    if (imageArray) {
        
        [shareParams SSDKSetupShareParamsByText:@"欢迎大家使用和了解我们的蓝牙设备"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://livevideo.gooorun.com:8282/uis/wxAuth/download.jsp"]
                                          title:@"蓝牙照明"
                                           type:SSDKContentTypeAuto];
    }
    
    [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateSuccess:
                
                
                break;
                
            case SSDKResponseStateFail:
                
                break;
                
            case SSDKResponseStateCancel:
                
                break;
            default:
                break;
        }
    }];

    
    
//    if ([WXApi isWXAppInstalled]) {
//        NSString * titleString = sharedTitle;
//        NSString * strContent  = sharedContent;
//        NSString * urlString   = sharedURL;
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon@2x" ofType:@"png"];
//        
//        
//    
//        //创建分享内容
//        id<ISSContent> publishContent = [ShareSDK content:strContent
//                                           defaultContent:@""
//                                                    image:[ShareSDK pngImageWithImage:[UIImage imageWithContentsOfFile:imagePath]]
//                                                    title:titleString
//                                                      url:urlString
//                                              description:nil
//                                                mediaType:SSPublishContentMediaTypeNews];
//        
//        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                             allowCallback:YES
//                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                              viewDelegate:nil
//                                                   authManagerViewDelegate:self];
//        
//        //        //在授权页面中添加关注官方微博
//        //        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//        //                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//        //                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//        //                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//        //                                        SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//        //                                        nil]];
//        
//        //显示分享菜单
//        [ShareSDK showShareViewWithType:ShareTypeWeixiSession
//                              container:nil
//                                content:publishContent
//                          statusBarTips:YES
//                            authOptions:authOptions
//                           shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
//                                                               oneKeyShareList:[NSArray defaultOneKeyShareList]
//                                                            cameraButtonHidden:YES
//                                                           mentionButtonHidden:NO
//                                                             topicButtonHidden:NO
//                                                                qqButtonHidden:NO
//                                                         wxSessionButtonHidden:NO
//                                                        wxTimelineButtonHidden:NO
//                                                          showKeyboardOnAppear:NO
//                                                             shareViewDelegate:self
//                                                           friendsViewDelegate:self
//                                                         picViewerViewDelegate:nil]
//                                 result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                     if (state == SSPublishContentStateSuccess) {
//                                         //纪录数据 表示发表成功
//                                         self.shareSuccess();
//                                     } else if (state == SSPublishContentStateFail) {
//                                         self.shareFail();
//                                     } else if (state == SSPublishContentStateCancel) {
//                                         NSLog(@"=====用户中途取消分享=====");
//                                         self.shareCancel();
//                                     }
//                                 }];
//        
//    }else{
//        [[WXReminderView shareInstance] addWarningRemindWithView:self.superview warningString:@"您的手机还没有安装微信！" remindBlock:nil];
////        [[WXReminderView shareInstance] addWarningRemindWithView:self.superview warningString:@"您的手机还没有安装微信！" remindBlock:nil];
//    }
    
}

#pragma mark - 发送给微信朋友圈
- (void)sendToPengYouQuanBtnPress {
    
    if (![WXApi isWXAppInstalled]) {
        [SVProgressHUD showErrorWithStatus:@"未安装微信客户端!"];
        return;
    }
    
     NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray *imageArray = @[[UIImage imageNamed:@"common_loading"]];
    if (imageArray) {

        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://livevideo.gooorun.com:8282/uis/wxAuth/download.jsp"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
    }
    
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateSuccess:
                
                
                break;
                
            case SSDKResponseStateFail:
                
                break;
                
            case SSDKResponseStateCancel:
                
                break;
            default:
                break;
        }
    }];

//    if ([WXApi isWXAppInstalled]) {
//        NSString * titleString = sharedTitle;
//        NSString * strContent  = sharedContent;
//        NSString * urlString   = sharedURL;
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon@2x" ofType:@"png"];
//        
//        //创建分享内容
//        
//        id<ISSContent> publishContent = [ShareSDK content:strContent
//                                           defaultContent:@""
//                                                    image:[ShareSDK pngImageWithImage:[UIImage imageWithContentsOfFile:imagePath]]
//                                                    title:titleString
//                                                      url:urlString
//                                              description:nil
//                                                mediaType:SSPublishContentMediaTypeNews];
//        
//        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                             allowCallback:YES
//                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                              viewDelegate:nil
//                                                   authManagerViewDelegate:self];
//        
//        //        //在授权页面中添加关注官方微博
//        //        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//        //                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//        //                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//        //                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//        //                                        SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//        //                                        nil]];
//        //
//        //显示分享菜单
//        [ShareSDK showShareViewWithType:ShareTypeWeixiTimeline
//                              container:nil
//                                content:publishContent
//                          statusBarTips:YES
//                            authOptions:authOptions
//                           shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
//                                                               oneKeyShareList:[NSArray defaultOneKeyShareList]
//                                                            cameraButtonHidden:YES
//                                                           mentionButtonHidden:NO
//                                                             topicButtonHidden:NO
//                                                                qqButtonHidden:NO
//                                                         wxSessionButtonHidden:NO
//                                                        wxTimelineButtonHidden:NO
//                                                          showKeyboardOnAppear:NO
//                                                             shareViewDelegate:self
//                                                           friendsViewDelegate:self
//                                                         picViewerViewDelegate:nil]
//                                 result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                     
//                                     if (state == SSPublishContentStateSuccess) {
//                                         //纪录数据 表示发表成功
//                                         self.shareSuccess();
//                                     } else if (state == SSPublishContentStateFail) {
//                                         self.shareFail();
//                                     } else if (state == SSPublishContentStateCancel) {
//                                         NSLog(@"=====用户中途取消分享=====");
//                                         self.shareCancel();
//                                     }
//                                 }];
//        
//    }else{
//         [[WXReminderView shareInstance] addWarningRemindWithView:self.superview warningString:@"您的手机还没有安装微信！" remindBlock:nil];
////        [[LMReminderView shareInstance] addWarningRemindWithView:self.superview warningString:@"您的手机还没有安装微信！" remindBlock:nil];
//    }
    
}


#pragma mark - 发送给QQ
- (void)sendToQQBtnPress {
    
    if (![QQApiInterface isQQInstalled]) {
        [SVProgressHUD showErrorWithStatus:@"未安装QQ客户端！"];
        return;
        
    }
     NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSArray *imageArray = @[[UIImage imageNamed:@"common_loading"]];
    if (imageArray) {

        [shareParams SSDKSetupShareParamsByText:@"这个是我蓝牙智能灯的分享内容啊啊啊啊啊啊啊啊"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://livevideo.gooorun.com:8282/uis/wxAuth/download.jsp"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
    }
    
    [ShareSDK share:SSDKPlatformTypeQQ parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateSuccess:
                
                
                break;
                
            case SSDKResponseStateFail:
                
                break;
                
            case SSDKResponseStateCancel:
                
                break;
            default:
                break;
        }
    }];

//    if ([QQApiInterface isQQInstalled]) {
//        NSString * titleString = sharedTitle;
//        NSString * strContent  = sharedContent;
//        NSString * urlString   = sharedURL;
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon@2x" ofType:@"png"];
//        
//        //创建分享内容
//        id<ISSContent> publishContent = [ShareSDK content:strContent
//                                           defaultContent:@""
//                                                    image:[ShareSDK pngImageWithImage:[UIImage imageWithContentsOfFile:imagePath]]
//                                                    title:titleString
//                                                      url:urlString
//                                              description:nil
//                                                mediaType:SSPublishContentMediaTypeNews];
//        
//        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                             allowCallback:YES
//                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                              viewDelegate:nil
//                                                   authManagerViewDelegate:self];
//        
//        //        //在授权页面中添加关注官方微博
//        //        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//        //                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//        //                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//        //                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//        //                                        SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//        //                                        nil]];
//        //
//        //显示分享菜单
//        [ShareSDK showShareViewWithType:ShareTypeQQ
//                              container:nil
//                                content:publishContent
//                          statusBarTips:YES
//                            authOptions:authOptions
//                           shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
//                                                               oneKeyShareList:[NSArray defaultOneKeyShareList]
//                                                            cameraButtonHidden:YES
//                                                           mentionButtonHidden:NO
//                                                             topicButtonHidden:NO
//                                                                qqButtonHidden:NO
//                                                         wxSessionButtonHidden:NO
//                                                        wxTimelineButtonHidden:NO
//                                                          showKeyboardOnAppear:NO
//                                                             shareViewDelegate:self
//                                                           friendsViewDelegate:self
//                                                         picViewerViewDelegate:nil]
//                                 result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                     
//                                     if (state == SSPublishContentStateSuccess) {
//                                         //纪录数据 表示发表成功
//                                         self.shareSuccess();
//                                     } else if (state == SSPublishContentStateFail) {
//                                         self.shareFail();
//                                     } else if (state == SSPublishContentStateCancel) {
//                                         NSLog(@"=====用户中途取消分享=====");
//                                         self.shareCancel();
//                                     }
//                                 }];
//        
//        
//    }else{
//         [[WXReminderView shareInstance] addWarningRemindWithView:self.superview warningString:@"您的手机还没有安装微信！" remindBlock:nil];
////        [[LMReminderView shareInstance] addWarningRemindWithView:self.superview warningString:@"您的手机还没有安装QQ！" remindBlock:nil];
//    }
    
}


#pragma mark - 发送给新浪
- (void)sendToWeiboBtnPress {
     NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray *imageArray = @[[UIImage imageNamed:@"common_loading"]];
    if (imageArray) {
       
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://livevideo.gooorun.com:8282/uis/wxAuth/download.jsp"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
    }
    
    [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateSuccess:
                self.shareSuccess();
                
                break;
                
            case SSDKResponseStateFail:
                self.shareFail();
                break;
                
            case SSDKResponseStateCancel:
                self.shareCancel();
                break;
            default:
                break;
        }
    }];
    
    
//    if ([QQApiInterface isQQInstalled]) {
//        NSString * titleString = sharedTitle;
//        NSString * strContent  = sharedContent;
//        NSString * urlString   = sharedURL;
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon@2x" ofType:@"png"];
//        
//        //创建分享内容
//        id<ISSContent> publishContent = [ShareSDK content:strContent
//                                           defaultContent:@""
//                                                    image:[ShareSDK pngImageWithImage:[UIImage imageWithContentsOfFile:imagePath]]
//                                                    title:titleString
//                                                      url:urlString
//                                              description:nil
//                                                mediaType:SSPublishContentMediaTypeNews];
//        
//        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                             allowCallback:YES
//                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                              viewDelegate:nil
//                                                   authManagerViewDelegate:self];
//        
//        //        //在授权页面中添加关注官方微博
//        //        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//        //                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//        //                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//        //                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//        //                                        SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//        //                                        nil]];
//        //
//        //显示分享菜单
//        [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
//                              container:nil
//                                content:publishContent
//                          statusBarTips:YES
//                            authOptions:authOptions
//                           shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
//                                                               oneKeyShareList:[NSArray defaultOneKeyShareList]
//                                                            cameraButtonHidden:YES
//                                                           mentionButtonHidden:NO
//                                                             topicButtonHidden:NO
//                                                                qqButtonHidden:NO
//                                                         wxSessionButtonHidden:NO
//                                                        wxTimelineButtonHidden:NO
//                                                          showKeyboardOnAppear:NO
//                                                             shareViewDelegate:self
//                                                           friendsViewDelegate:self
//                                                         picViewerViewDelegate:nil]
//                                 result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                     
//                                     if (state == SSPublishContentStateSuccess) {
//                                         //纪录数据 表示发表成功
//                                         self.shareSuccess();
//                                     } else if (state == SSPublishContentStateFail) {
//                                         self.shareFail();
//                                     } else if (state == SSPublishContentStateCancel) {
//                                         NSLog(@"=====用户中途取消分享=====");
//                                         self.shareCancel();
//                                     }
//                                 }];
//        
//    }else{
//         [[WXReminderView shareInstance] addWarningRemindWithView:self.superview warningString:@"您的手机还没有安装微信！" remindBlock:nil];
////        [[LMReminderView shareInstance] addWarningRemindWithView:self.superview warningString:@"您的手机还没有安装新浪微博！" remindBlock:nil];
//    }
    
}

-(void)showWithDuration:(CGFloat)duration
{
    self.inDuration = duration;
    [_currentView addSubview:self];
    self.maskBtn.alpha = 0.0;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_currentView.mas_bottom);
        make.width.mas_equalTo(ScreenWidth);
        make.centerX.mas_equalTo(_currentView.mas_centerX);
        make.height.mas_equalTo(DefaultHeight);
    }];
    [self.wxSessionBtn showLargeAnimation:duration+0.3];
    [self.wxTimeLineBtn showLargeAnimation:duration+0.3];
    [self.qqBtn showLargeAnimation:duration+0.3];
    [self.weiboBtn showLargeAnimation:duration+0.3];
    [self layoutIfNeeded];
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.currentView.mas_bottom).offset(-DefaultHeight);
        }];
        _maskBtn.alpha = 0.7;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}



//- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
//
//{
//    viewController.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
//    
//}

-(UIButton *)maskBtn
{
    if (!_maskBtn) {
        _maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_currentView addSubview:_maskBtn];
        _maskBtn.backgroundColor = [UIColor blackColor];
        [_currentView addSubview:self.maskBtn];
        [_maskBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        _maskBtn.alpha = 0.0;
        [_maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_currentView);
        }];
        [_currentView insertSubview:_maskBtn belowSubview:self];
    }
    return _maskBtn;
}

-(void)clickCancelBtn
{
    [UIView animateWithDuration:self.inDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.currentView.mas_bottom);
        }];
        _maskBtn.alpha = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)resetView
{
    [self removeFromSuperview];
    _maskBtn.alpha = 0.0;
}

-(void)addShareSuccess:(dispatch_block_t)sucess withFail:(dispatch_block_t)fail withCancel:(dispatch_block_t)cancel
{
    self.shareSuccess = sucess;
    self.shareFail = fail;
    self.shareCancel = cancel;
}

#pragma -mark 网络交互


-(void)getCat
{
//    if (isUserLogin()) {
//        NSDictionary *params = @{@"actiontype":@"live_share",@"ticket":getUserTicket(),@"memberid":getUserId()};;
//        [[LMNetworkManager shareInstance] requestForUrlWithMethodPOST:Member_GetCat withParams:params withSuccess:^(NSUInteger dataCount, id resonseObj, BOOL inComplete, BOOL isSuccess, NSString *message) {
//            
//        } withFail:^(NSUInteger serviceCode, NSString *message) {
//            
//        }];
//    }
}

@end

