//
//  BLEDevice.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/18.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import RealmSwift

// 设备链路状态
enum LinkState: Int {
    case unlink // 已断开
    case linked // 连接中
}

class BLEDevice: Object {
    dynamic var uuid: String?
    dynamic var name: String?
    dynamic var deviceId: Int32 = 0
    
    var linkState = LinkState.unlink
    var color = UIColor.white
    var level = UInt8(0)
    var power = false
    
    
    override static func primaryKey() -> String? {
        return "deviceId"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["linkState", "color", "level", "power"]
    }
}
