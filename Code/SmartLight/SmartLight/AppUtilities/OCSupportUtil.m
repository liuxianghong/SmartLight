//
//  OCSupportUtil.m
//  Drone
//
//  Created by 刘向宏 on 2017/2/20.
//  Copyright © 2017年 fimi. All rights reserved.
//

#import "OCSupportUtil.h"

@implementation OCSupportUtil

+ (void)JumpSystemSetting:(NSString *)prefs crypts:(NSArray<NSString *> *)crypts {
    NSString *rootPrefs = [NSString stringWithFormat:@"Prefs:root=%@",prefs];
    NSURL *url = [NSURL URLWithString:rootPrefs];
    Class class = NSClassFromString(crypts[0]);
    SEL s1 = NSSelectorFromString(crypts[1]);
    SEL s2 = NSSelectorFromString(crypts[2]);
    [[class performSelector:s1] performSelector:s2 withObject:url withObject:nil];
}

@end
