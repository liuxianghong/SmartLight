//
//  CommonUtility.m
//  Intelligentlamp
//
//  Created by L on 16/8/26.
//  Copyright © 2016年 L. All rights reserved.
//

#import "CommonUtility.h"
#import "NSString+Extension.h"

@implementation CommonUtility

+ (CommonUtility *)global
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark --加密
+ (NSString*)encryptMD5String:(NSString*)string {
    return string;
    return [string md5Encrypt];
}

@end
