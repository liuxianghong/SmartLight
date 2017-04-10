//
//  CommonUtility.h
//  Intelligentlamp
//
//  Created by L on 16/8/26.
//  Copyright © 2016年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma -mark 用户信息存取

static inline void setUserToken(NSString *token)
{
    [UserDefaults setObject:token forKey:@"token"];
    [UserDefaults synchronize];
}

static inline NSString * getUserToken()
{
    return [UserDefaults objectForKey:@"token"];
}

static inline void setUserId(NSNumber *userId)
{
    [UserDefaults setObject:userId forKey:@"userId"];
    [UserDefaults synchronize];
}

static inline NSString * getUserId()
{
    return [UserDefaults objectForKey:@"userId"];
}

static inline BOOL isUserLogin()
{
    if (getUserId() == nil)
        return NO;
    return YES;
}

static inline void removeUserId()
{
    [UserDefaults removeObjectForKey:@"userId"];
}

@interface CommonUtility : NSObject

+ (CommonUtility *)global;
@property (nonatomic , assign) BOOL needUpdateInterest;

+ (NSString*)encryptMD5String:(NSString*)string;
@end
