//
//  DeviceManager.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/19.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import RealmSwift

class DeviceManager {

    static let shareManager = DeviceManager()
    
    fileprivate var bleDevicesIn = [BLEDevice]()
    
    var bleDevices: [BLEDevice] {
        return bleDevicesIn
    }
    
    fileprivate init() {
        bleDevicesIn = loadAllDevices()
    }
    
    fileprivate func loadAllDevices() -> [BLEDevice] {
        let realm = try! Realm()
        let devices = realm.objects(BLEDevice.self)
        var resluts = [BLEDevice]()
        for device in devices {
            resluts.append(device)
        }
        return resluts
    }
}
