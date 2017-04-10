//
//  UserNameChangeViewController.h
//  Intelligentlamp
//
//  Created by L on 16/9/19.
//  Copyright © 2016年 L. All rights reserved.
//
typedef void(^ChangeContentBlock)(NSString *str);
#import "RootViewController.h"

@interface UserNameChangeViewController : RootViewController


@property (nonatomic ,copy) NSString *titleStr;//标题
@property (nonatomic ,copy) NSString *content;//修改的内容

@property (nonatomic ,copy) ChangeContentBlock changeContentBlock;
@end
