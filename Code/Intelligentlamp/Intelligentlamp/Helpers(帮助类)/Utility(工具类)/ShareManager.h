//
//  ShareManager.h
//  Intelligentlamp
//
//  Created by L on 16/8/25.
//  Copyright © 2016年 L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <WeiboSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@interface ShareManager : NSObject

+(ShareManager *)shareInstance;
-(void)registerPlatform;
@end
