//
//  BLEDevice.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/18.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import RealmSwift

class BLEDevice: Object {
    dynamic var uuid: String?
    dynamic var name: String?
    dynamic var deviceId: Int32 = 0
    
    
    override static func primaryKey() -> String? {
        return "deviceId"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["tmpID"]
    }
    
    func save() {
        guard let realm = try? Realm(),let _ = uuid, deviceId > 0 else {return}
        try? realm.write {
            realm.add(self)
        }
    }
    
    class func LoadAllDevices() -> [BLEDevice] {
        let realm = try! Realm()
        let devices = realm.objects(BLEDevice.self)
        var resluts = [BLEDevice]()
        for device in devices {
            resluts.append(device)
        }
        return resluts
    }
}
