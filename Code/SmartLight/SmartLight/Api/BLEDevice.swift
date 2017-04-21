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
    
    var linkState = LinkState.unlink {
        didSet {
            if linkState == .linked {
                linkedTimeInterval = 30
            }
            guard oldValue != linkState else {
                return
            }
            update?(self)
        }
    }
    var color = UIColor.white {
        didSet {
            guard oldValue.rgbValue() != color.rgbValue() else {
                return
            }
            update?(self)
        }
    }
    var level = UInt8(0) {
        didSet {
            guard oldValue != level else {
                return
            }
            update?(self)
        }
    }
    var power = false {
        didSet {
            guard oldValue != power else {
                return
            }
            update?(self)
        }
    }
    var temperature = UInt8(0) {
        didSet {
            guard oldValue != temperature else {
                return
            }
            update?(self)
        }
    }
    
    var update: ((BLEDevice) -> ())?
    
    var isInvalid: Bool {
        get {
            return (timer == nil)
        }
    }
    
    fileprivate var timer: DispatchSourceTimer?
    fileprivate var linkedTimeInterval = Foundation.TimeInterval(0)
    
    override static func primaryKey() -> String? {
        return "deviceId"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["linkState", "color", "level", "power", "temperature", "update", "timer", "linkedTimeInterval"]
    }
    
    func startCheckLink() {
        guard timer == nil else {return}
        
        timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0), queue: DispatchQueue.main)
        guard let timer = timer else {return}
        
        let interval = UInt64(1 * 1000)*NSEC_PER_MSEC
        let start = DispatchTime.now() + Double(Int64(interval)) / Double(NSEC_PER_SEC)
        timer.scheduleRepeating(deadline: start, interval: DispatchTimeInterval.seconds(1))
        timer.setEventHandler { [weak self]() -> Void in
            self?.checkLink()
        }
        timer.resume()
    }
    
    func stopCheckLink() {
        guard let timer = timer else {return}
        timer.cancel()
        self.timer = nil
    }
    
    fileprivate func checkLink() {
        linkedTimeInterval -= 1
        if linkedTimeInterval < 20 {
            DeviceSession.request(self, command: .state, completion: nil)
        }
        if linkedTimeInterval < 0 {
            linkState = .unlink
        }
    }
    
    deinit {
        stopCheckLink()
    }
}
