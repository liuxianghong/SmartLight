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
            device.startCheckLink()
        }
        return resluts
    }
    
    func addDevice(device: BLEDevice) {
        guard let realm = try? Realm(),let _ = device.uuid, device.deviceId > 0 else {return}
        try? realm.write {
            realm.add(device, update: true)
            for item in bleDevicesIn {
                if item.deviceId == device.deviceId {
                    return
                }
            }
            bleDevicesIn.append(device)
            device.startCheckLink()
        }
    }
    
    func deleteDevice(device: BLEDevice) {
        guard let realm = try? Realm(),let _ = device.uuid, device.deviceId > 0 else {return}
        if let index = bleDevicesIn.index(of: device) {
            device.stopCheckLink()
            try? realm.write {
                realm.delete(device)
                bleDevicesIn.remove(at: index)
            }
        }
        
    }
}
