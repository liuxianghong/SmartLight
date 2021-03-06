//
//  AppDelegate.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/10.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let _ = BLEManager.shareManager
        
        let config = Realm.Configuration(
            // 设置新的架构版本。这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
            schemaVersion: 1,
            
            // 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
            migrationBlock: { migration, oldSchemaVersion in
                // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
                }
        })
        
        // 告诉 Realm 为默认的 Realm 数据库使用这个新的配置对象
        Realm.Configuration.defaultConfiguration = config
        
        for index in 1...2 {
            let devcie = BLEDevice()
            devcie.deviceId = 32771 + index
            devcie.uuid = "BDBCB373-E363-890F-A101-F5B094368242"
            devcie.userId = "60691"
            // 获取默认的 Realm 数据库
            let realm = try! Realm()
            try! realm.write {
                realm.add(devcie, update: true)
            }
        }
        
        let fileLogger = DDFileLogger(logFileManager: DDLogFileManagerDefault())!
        fileLogger.maximumFileSize = 10 * 1024 * 1024
        fileLogger.rollingFrequency = 240 * 60 * 60
        fileLogger.logFileManager.maximumNumberOfLogFiles = 30
        fileLogger.logFileManager.logFilesDiskQuota = 0
        DDLog.add(DDTTYLogger.sharedInstance)
        DDLog.add(fileLogger)
        defaultDebugLevel = DDLogLevel.all

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

