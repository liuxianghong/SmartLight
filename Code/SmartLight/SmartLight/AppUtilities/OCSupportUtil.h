//
//  OCSupportUtil.h
//  Drone
//
//  Created by 刘向宏 on 2017/2/20.
//  Copyright © 2017年 fimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCSupportUtil : NSObject

+ (void)JumpSystemSetting:(NSString *)prefs crypts:(NSArray<NSString *> *)crypts;

@end
