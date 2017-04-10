//
//  ShareManager.m
//  Intelligentlamp
//
//  Created by L on 16/8/25.
//  Copyright © 2016年 L. All rights reserved.
//

#import "ShareManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
//#import <ShareSDKExtension/SSEBaseUser.h>
//以下是腾讯SDK的依赖库：
//libsqlite3.dylib

//微信SDK头文件
#import "WXApi.h"
//以下是微信SDK的依赖库：
//libsqlite3.dylib

//新浪微博SDK头文件
#import "WeiboSDK.h"


@implementation ShareManager

+ (ShareManager *)shareInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance                         = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)registerPlatform
{
    
    [ShareSDK registerApp:@"16b0b830d91da"
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeCopy),
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             //                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                         {
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             [WeiboSDK enableDebugMode:YES];
                         }
                             break;
                             
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"1766404198"
                                                appSecret:@"dbd72a4efa031ce1ab7e2a5271365db9"
                                              redirectUri:@"https://www.baidu.com/"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                      
                      
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx2233f5c78a7eb75b"
                                            appSecret:@"72a0b3d27cf74b3d7165bacea7d90b42"];
                      break;
                      
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1105692796"
                                           appKey:@"moKcbjYlfTjkOBYT"
                                         authType:SSDKAuthTypeBoth];
                      break;
                      
                  default:
                      break;
              }
          }];
}

@end

