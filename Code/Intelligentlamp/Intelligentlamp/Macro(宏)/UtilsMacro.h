//
//  UtilsMacro.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h


#endif /* UtilsMacro_h */

#pragma mark - ShareSDK
#define SHARE_APPKEY            @"df6629023e02"

#define SINAWEIBO_APPKEY        @"1766404198"
#define SINAWEIBO_SECRET        @"dbd72a4efa031ce1ab7e2a5271365db9"
#define SINAWEIBO_REDIRECTURL   @"https://www.baidu.com/"
#define QQZONE_APPKEY           @"1105344755"
#define QQZONE_SECRET           @"xbP2w6pOFsF6XVoV"
#define QQ_APPKEY               @"1105344755"
#define WEICHAT_APPKEY          @"wx8e6c3a0f11bea8bf"
#define WEICHAT_SECRET          @"1c4579c1651962cfab745a7d6385364b"


//低于某个系统版本
#define iOS9_AndEarlier         ([[[UIDevice currentDevice]systemVersion]floatValue] < 10.0)
#define iOS8_AndEarlier         ([[[UIDevice currentDevice]systemVersion]floatValue] < 9.0)
#define iOS7_AndEarlier         ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0)
#define iOS6_AndEarlier         ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)

//高于某个系统版本
#define iOS9_AndLater           ([[[UIDevice currentDevice]systemVersion]floatValue] >= 9.0)
#define iOS8_AndLater           ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
#define iOS7_AndLater           ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
#define iOS6_AndLater           ([[[UIDevice currentDevice]systemVersion]floatValue] >= 6.0)

//当前系统版本
#define iOS9 iOS9_AndEarlier&&iOS9_AndLater
#define iOS8 iOS8_AndEarlier&&iOS8_AndLater
#define iOS7 iOS7_AndEarlier&&iOS7_AndLater
#define iOS6 iOS6_AndEarlier&&iOS6_AndLater

#define WEAKSELF  typeof(self) __weak weakSelf=self;

//iPhone型号（根据尺寸）
#define Pad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960),[[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334),[[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define ApplicationShare                    ((AppDelegate *)[UIApplication sharedApplication])
#define AppVersion                          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define NavBarHeight                        self.navigationController.navigationBar.bounds.size.height
#define TabBarHeight                        self.tabBarController.tabBar.bounds.size.height
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define Screen                        [[UIScreen mainScreen] bounds]
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewWidth                       self.view.bounds.size.width
#define SelfViewHeight                      self.view.bounds.size.height
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define RGB(r, g, b)                        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEXCOLOR(c)                         [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]
#define F(string, args...)                  [NSString stringWithFormat:string, args]
#define ALERT(title, msg)                   [[[UIAlertView alloc]     initWithTitle:title\
message:msg\
delegate:nil\
cancelButtonTitle:@"确定"\
otherButtonTitles:nil] show]
#define URL(u)                               [NSURL URLWithString:(u)]


#define AllLampTitleColor HEXCOLOR(0x8c8c8e)
#define AllLampDescribeColor HEXCOLOR(0x8c8c8e)
#define AllLampLineColor HEXCOLOR(0x19181b)
#define AllCellBgColor RGB(28,27,31)
#define ClearColor [UIColor clearColor]
#define AllBgColor HEXCOLOR(0x19181b)
#define AllTitleColor RGB(60, 60, 60)
#define AllDetailColor RGB(60, 60, 60)
#define AllRedLine RGB(233,93,99)


