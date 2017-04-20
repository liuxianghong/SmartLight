//
//  DeviceSession.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/19.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit

enum SessionComand {
    case power
    case level
    case color
    case colorTemp
    case state
    case discovery
    case associate
    case reset
}

enum SessionError: Int {
    case success // 成功
    case timeout // 超时
    case unknown
}

class DeviceSession: NSObject {

    fileprivate var device: BLEDevice!
    fileprivate var command: SessionComand!
    fileprivate let interval = Foundation.TimeInterval(0.01)
    fileprivate var stepTimer: DispatchSource!
    fileprivate var elapsed = Foundation.TimeInterval(0)
    fileprivate var timeout = Foundation.TimeInterval(0)
    fileprivate var expiredTimer: DispatchSource!
    fileprivate var expired = Foundation.TimeInterval(0)
    fileprivate var resendCount = UInt32(0)
    fileprivate var resendLimit = UInt32(0)
    fileprivate var completion: ((SessionError, BLEDevice?) -> Void)?
    fileprivate var requstId = NSNumber(value: 0)
    
    fileprivate let meshServiceApi = MeshServiceApi.sharedInstance() as! MeshServiceApi
    fileprivate let powerModelApi = PowerModelApi.sharedInstance() as! PowerModelApi
    fileprivate let lightModelApi = LightModelApi.sharedInstance() as! LightModelApi
    fileprivate let configModelApi = ConfigModelApi.sharedInstance() as! ConfigModelApi
    
    @discardableResult
    class func request(_ device: BLEDevice
        , command: SessionComand
        , timeout: Foundation.TimeInterval = 0
        , resend: UInt32 = 0
        , expired: Foundation.TimeInterval = 3
        , completion: ((SessionError, BLEDevice?) -> Void)?)
        -> DeviceSession
    {
        let session = DeviceSession()
        session.device = device
        session.command = command
        session.timeout = timeout
        session.expired = expired
        session.resendLimit = resend
        
        session.completion = { (error, message) -> Void in
            completion?(error, message)
            session.stop()
        }
        
        NotificationCenter.default.addObserver(session
            , selector: #selector(deviceDidRecvMsg(_:))
            , name: BLEManager.NOTICE_RECV_MESSAGE
            , object: BLEManager.shareManager
        )
        
        // 消息超时时间大于0才打开定时器，否则不需要此操作
        if timeout > 0 {
            session.startStepTimer()
        }
        
        // 函数超时时间不为0才打开定时器，否则不需要此操作
        if expired > 0 {
            session.startExpiredTimer()
        }
        
        // 发送命令
        session.send()
        
        return session
    }
    
    
    
    func deviceDidRecvMsg(_ sender: Notification) {
        guard let message = sender.userInfo?["recvMsg"] as? [String: Any]
            , let cmd = message["cmd"] as? NoticeCmd else
        {
            return
        }
        
        switch command! {
        case .discovery:
            discoveryRecvHandle(cmd: cmd, message: message)
        case .associate:
            guard let meshRequestId = message["meshRequestId"] as? NSNumber
                , meshRequestId == self.requstId else {
                return
            }
            associateRecvHandle(cmd: cmd, message: message)
            
        case .reset:
            resetRecvHandle(cmd: cmd, message: message)
        case .power:
            guard let meshRequestId = message["meshRequestId"] as? NSNumber
                , meshRequestId == self.requstId else {
                    return
            }
            powerRecvHandle(cmd: cmd, message: message)
        case .colorTemp:
            guard let meshRequestId = message["meshRequestId"] as? NSNumber
                , meshRequestId == self.requstId else {
                    return
            }
            lightStateRecvHandle(cmd: cmd, message: message)
        case .level:
            guard let meshRequestId = message["meshRequestId"] as? NSNumber
                , meshRequestId == self.requstId else {
                    return
            }
            lightStateRecvHandle(cmd: cmd, message: message)
        case .state:
            guard let meshRequestId = message["meshRequestId"] as? NSNumber
                , meshRequestId == self.requstId else {
                    return
            }
            lightStateRecvHandle(cmd: cmd, message: message)
        case .color:
            guard let meshRequestId = message["meshRequestId"] as? NSNumber
                , meshRequestId == self.requstId else {
                    return
            }
            lightStateRecvHandle(cmd: cmd, message: message)
        }
    }
    
    fileprivate func send() {
        switch command! {
        case .discovery:
            meshServiceApi.setDeviceDiscoveryFilterEnabled(true)
        case .associate:
            let uuid = CBUUID(string: device.uuid!)
            let hash = self.meshServiceApi.getDeviceHash(from: uuid)
            requstId = meshServiceApi.associateDevice(hash
                , authorisationCode: nil)
        case .reset:
            configModelApi.resetDevice(self.device.deviceId as NSNumber)
        case .power:
            requstId = powerModelApi.setPowerState(device.deviceId as NSNumber
                , state: device.power ? 1 : 0
                , acknowledged: true)
        case .colorTemp:
            requstId = lightModelApi.setColorTemperature(device.deviceId as NSNumber
                , temperature: device.temperature as NSNumber
                , duration: 0)
        case .level:
            requstId = lightModelApi.setLevel(device.deviceId as NSNumber
                , level: device.level as NSNumber
                , acknowledged: true)
        case .state:
            requstId = lightModelApi.getState(device.deviceId as NSNumber)
        case .color:
            requstId = lightModelApi.setRgb(device.deviceId as NSNumber
                , red: Int(device.color.red * 255) as NSNumber
                , green: Int(device.color.green * 255) as NSNumber
                , blue: Int(device.color.blue * 255) as NSNumber
                , level: device.level as NSNumber
                , duration: 0
                , acknowledged: true)
        }
    }
    
    func stop() {
        NotificationCenter.default.removeObserver(self)
        self.stopStepTimer()
        self.stopExpiredTimer()
        self.elapsed = 0
        self.resendLimit = 0
        self.completion = nil
        
        switch command! {
        case .discovery:
            meshServiceApi.setDeviceDiscoveryFilterEnabled(false)
        case .reset:
            break
        default:
            if requstId != 0 {
                meshServiceApi.killTransaction(requstId)
            }
        }
    }
    
    fileprivate func discoveryRecvHandle(cmd: NoticeCmd, message: [String: Any]) {
        switch cmd {
        case .discover:
            if let uuid = message["uuid"] as? CBUUID
            {
                device.uuid = uuid.uuidString
                self.completion?(.success, self.device)
            }
        default:
            break
        }
    }
    
    fileprivate func associateRecvHandle(cmd: NoticeCmd, message: [String: Any]) {
        switch cmd {
        case .associate:
            if let deviceId = message["deviceId"] as? Int {
                requstId = 0
                self.device.deviceId = Int32(deviceId)
                self.completion?(.success, self.device)
            }
        case .associating:
            break
        default:
            self.completion?(.timeout, self.device)
        }
    }
    
    fileprivate func resetRecvHandle(cmd: NoticeCmd, message: [String: Any]) {
        switch cmd {
        case .reset:
            if let deviceId = message["deviceId"] as? Int32, device.deviceId == deviceId {
                self.completion?(.success, self.device)
            }
        case .appearanceating:
            if let deviceHash = message["deviceHash"] as? NSData {
                let data = meshServiceApi.getDeviceHash(from: CBUUID(string: device.uuid!))!
                if data.hashValue == deviceHash.hashValue {
                    self.completion?(.success, self.device)
                }
            }
        default:
            break
        }
    }
    
    fileprivate func powerRecvHandle(cmd: NoticeCmd, message: [String: Any]) {
        switch cmd {
        case .powerState:
            if let state = message["state"] as? Int
                , let deviceId = message["deviceId"] as? Int32
                , device.deviceId == deviceId {
                requstId = 0
                device.power = (state == 1)
                self.device.linkState = .linked
                self.completion?(.success, self.device)
            }
        default:
            self.completion?(.timeout, self.device)
        }
    }
    
    fileprivate func lightStateRecvHandle(cmd: NoticeCmd, message: [String: Any]) {
        switch cmd {
        case .lightState:
            if let state = message["state"] as? Int
                , let deviceId = message["deviceId"] as? Int32
                , device.deviceId == deviceId
                , let red = message["red"] as? UInt8
                , let green = message["green"] as? UInt8
                , let blue = message["blue"] as? UInt8
                , let level = message["level"] as? UInt8
                , let colorTemperature = message["colorTemperature"] as? UInt8 {
                requstId = 0
                device.power = (state == 1)
                device.temperature = colorTemperature
                device.level = level
                device.color = UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
                self.device.linkState = .linked
                self.completion?(.success, self.device)
            }
        default:
            self.completion?(.timeout, self.device)
        }
    }
    
    fileprivate func startStepTimer() {
        guard stepTimer == nil else {return}
        stepTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0), queue: DispatchQueue.main) /*Migrator FIXME: Use DispatchSourceTimer to avoid the cast*/ as! DispatchSource
        guard let timer = stepTimer else {return}
        
        let interval = UInt64(self.interval * 1000) * NSEC_PER_MSEC
        let start = DispatchTime.now() + Double(Int64(interval)) / Double(NSEC_PER_SEC)
        timer.scheduleRepeating(deadline: start, interval: .milliseconds(Int(self.interval * 1000)), leeway: .milliseconds(0))
        timer.setEventHandler { [weak self]() -> Void in
            self?.stepTimerTrigger()
        }
        timer.resume()
    }
    
    fileprivate func stopStepTimer() {
        guard let timer = stepTimer else {return}
        timer.cancel()
        stepTimer = nil
    }
    
    fileprivate func stepTimerTrigger() {
        elapsed += interval
        if elapsed >= timeout {
            if resendCount >= resendLimit && expiredTimer == nil {
                completion?(.timeout, self.device)
            } else {
                elapsed = 0
                if resendCount < resendLimit {
                    self.send()
                    resendCount += 1
                }
            }
        }
    }
    
    fileprivate func startExpiredTimer() {
        guard expiredTimer == nil else {return}
        expiredTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0), queue: DispatchQueue.main) /*Migrator FIXME: Use DispatchSourceTimer to avoid the cast*/ as! DispatchSource
        guard let timer = expiredTimer else {return}
        
        let interval = UInt64(self.expired * 1000) * NSEC_PER_MSEC
        let start = DispatchTime.now() + Double(Int64(interval)) / Double(NSEC_PER_SEC)
        timer.scheduleRepeating(deadline: start, interval: .milliseconds(Int(self.interval * 1000)), leeway: .milliseconds(0))
        timer.setEventHandler { [weak self]() -> Void in
            self?.completion?(.timeout, self?.device)
        }
        timer.resume()
    }
    
    fileprivate func stopExpiredTimer() {
        guard let timer = expiredTimer else {return}
        timer.cancel()
        expiredTimer = nil
    }
}
