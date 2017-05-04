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
    
    fileprivate var nameDic = [Int: String]()
    
    var userId: String? {
        didSet {
            guard oldValue != userId else {
                return
            }
            bleDevicesIn = loadAllDevices()
        }
    }
    
    var token: String?
    
    var bleDevices: [BLEDevice] {
        return bleDevicesIn
    }
    
    var linking = false {
        didSet {
            guard oldValue != linking else {
                return
            }
            
            if !linking {
                for device in bleDevicesIn {
                    device.linkState = .unlink
                }
            }
        }
    }
    
    fileprivate init() {
        bleDevicesIn = loadAllDevices()
    }
    
    fileprivate func loadAllDevices() -> [BLEDevice] {
        let realm = try! Realm()
        let devices = realm.objects(BLEDevice.self).filter("userId = '\(userId ?? "0")'")
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
    
    func updateAppearance(_ deviceHash: Data!, appearanceValue: Data!, shortName: Data!) {
        if let name = String(data: shortName, encoding: String.Encoding.utf8) {
            nameDic[deviceHash.hashValue] = name
        }
    }
    
    func updateDeviceList(_ list: [ServerHomeLampResult]?) {
        guard let list = list else {
            return
        }
    }
}
