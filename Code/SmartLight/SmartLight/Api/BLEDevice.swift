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
    dynamic var deviceId: Int16 = 0
    
    override static func primaryKey() -> String? {
        return "deviceId"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["tmpID"]
    }
    
    func save() {
        guard let realm = try? Realm() else {return}
        try? realm.write {
            realm.add(self)
        }
    }
}
