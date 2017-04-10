//
//  AppDelegate.m
//  Intelligentlamp
//
//  Created by L on 16/8/19.
//  Copyright © 2016年 L. All rights reserved.
//

#import "AppDelegate.h"
#import "MineViewController.h"
#import "ScenarioViewController.h"
#import "BulbViewController.h"
#import "GroupViewController.h"
#import "WXTabBarViewController.h"
#import "IQKeyBoardManager.h"
#import "ShareManager.h"
#import <SMS_SDK/SMSSDK.h>
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //ShareSDK注册
    [[ShareManager shareInstance] registerPlatform];
    
    //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:@"16b0b830d91da"
             withSecret:@"996263ffdc057dc8edf2c8759125c823"];
    
    //设置导航条背景图片
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"BottomTabBG.png"] forBarMetrics:UIBarMetricsDefault];

    // Override point for customization after application launch.
    self.window                        = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor        = [UIColor whiteColor];
    self.wxTabBarVC = [[WXTabBarViewController alloc]init];
   
    [self.window makeKeyAndVisible];
   
    if (isUserLogin() == NO) {
        
        LoginViewController *vc = [[LoginViewController alloc]init];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController     = nv;
        
    }else{
         [self loadControllers];
    }
    
    
    //登录成功之后切换控制器的通知
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice) name:@"NoticeLoginUserInfoRefresh" object:nil];
    
    //键盘管理类增加
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    return YES;
}

- (void)loadControllers{
    
    //现场 发现 消息 我的
    MineViewController *controller1    = [[MineViewController alloc] init];
    UINavigationController *nav1       = [[UINavigationController alloc]initWithRootViewController:controller1];
    nav1.navigationBar.backgroundColor = [UIColor blackColor];
    ScenarioViewController  *controller2 = [[ScenarioViewController  alloc] init];
    UINavigationController *nav2       = [[UINavigationController alloc]initWithRootViewController:controller2];
    nav2.navigationBar.backgroundColor = [UIColor blackColor];
    BulbViewController  *controller3     = [[BulbViewController alloc] init];
    UINavigationController *nav3       = [[UINavigationController alloc]initWithRootViewController:controller3];
    nav3.navigationBar.backgroundColor = [UIColor blackColor];
    GroupViewController  *controller4    = [[GroupViewController  alloc] init];
    UINavigationController *nav4       = [[UINavigationController alloc]initWithRootViewController:controller4];
    nav4.navigationBar.backgroundColor = [UIColor blackColor];
    
    NSMutableArray *arr                = [[NSMutableArray alloc] initWithObjects:nav3,nav4,nav2,nav1,nil];
    NSArray *titleArr                  = [NSArray arrayWithObjects:@"我的灯泡-Activated@2x", @"分组-Activated@2x" ,@"场景-Activated@2x" ,@"我的-Activated@2x", nil];
    NSArray *imgArr                    = [NSArray arrayWithObjects:@"我的灯泡-Un-Activated-@2x.png",@"分组-Un-Activated@2x",@"场景-UnActivated@2x",@"我的-UnActivated@2x",nil];
    NSArray *selArr                    = [NSArray arrayWithObjects:@"我的灯泡",@"分组",@"场景",@"我的", nil];
    self.wxTabBarVC = [[WXTabBarViewController alloc]initWithTitle:selArr imgArr:imgArr selectArr:titleArr bgImage:[UIImage imageNamed:@"BottomTabBG.png"]];
    
    [self.wxTabBarVC setViewControllers:arr animated:YES];;
    self.wxTabBarVC.selectedIndex      = 0;
    self.window.rootViewController     = self.wxTabBarVC;

    
}

- (void)notice{
    
    [self loadControllers];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
