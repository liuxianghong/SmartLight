//
//  NetworkUtil.swift
//  Drone
//
//  Created by 刘向宏 on 2017/3/1.
//  Copyright © 2017年 fimi. All rights reserved.
//

import UIKit
import CoreTelephony
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork
import Reachability

enum NetworkReachableState: Int {
    case reachable
    case unreachable
    case restricted
    case unknown
}

class NetworkUtil: NSObject {
    
    static let NetworkReachableStateChanged = NSNotification.Name(rawValue: "NetworkReachableStateChangedNotification")
    
    class var SSID: String? {
        guard let interfaces: CFArray = CNCopySupportedInterfaces() else {return nil}
        guard let if0: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, 0) else {return nil}
        let interfaceName: CFString = unsafeBitCast(if0, to: CFString.self)
        guard let dictionary = CNCopyCurrentNetworkInfo(interfaceName) as? [String: Any] else {return nil}
        return dictionary[kCNNetworkInfoKeySSID as String] as? String
    }
    
    class var reachableState: NetworkReachableState {
        return NetworkUtil.instance.reachableStateIn
    }
    
    class var isReachableViaWiFi: Bool {
        return NetworkUtil.instance.reachability.isReachableViaWiFi()
    }
    
    class func statrNotifier() {
        NetworkUtil.instance.canNotify = true
    }
    
    class func stopNotifier() {
        NetworkUtil.instance.canNotify = false
    }
    
    fileprivate static let instance = NetworkUtil()
    
    fileprivate var cellularData: AnyObject?
    
    fileprivate let reachability = Reachability.forInternetConnection()!
    
    fileprivate var restrictedState = CTCellularDataRestrictedState.restrictedStateUnknown
    
    fileprivate var reachableStateIn = NetworkReachableState.unknown {
        didSet {
            guard reachableStateIn != oldValue else {
                return
            }
            notify()
        }
    }
    
    fileprivate var canNotify = false
    
    fileprivate override init() {
        super.init()
        if #available(iOS 9.0, *) {
            let cellularData = CTCellularData()
            cellularData.cellularDataRestrictionDidUpdateNotifier = {[weak self](state: CTCellularDataRestrictedState) -> Void in
                self?.restrictedState = state
                self?.checkReachable()
            }
            self.cellularData = cellularData
        } else {
            // Fallback on earlier versions
        }
        
        reachability.reachableBlock = {[weak self](reach: Reachability!) -> Void in
            self?.checkReachable()
        }
        reachability.unreachableBlock = {[weak self](reach: Reachability!) -> Void in
            self?.checkReachable()
        }
        reachability.reachableOnWWAN = true
        reachability.stopNotifier()
    }
    
    fileprivate func checkReachable() {
        switch reachability.currentReachabilityStatus() {
        case .NotReachable:
            checkRestricted()
        default:
            reachableStateIn = .reachable
        }
    }
    
    fileprivate func checkRestricted() {
        var state = NetworkReachableState.unreachable
        switch restrictedState {
        case .restricted:
            if let ssid = NetworkUtil.SSID {
                if let range = ssid.range(of: "Mi_RC") {
                    if range.lowerBound == ssid.startIndex {
                        state = .restricted
                    }
                }
            } else {
                state = .restricted
            }
        default:
            state = .unreachable
        }
        reachableStateIn = state
    }
    
    fileprivate func notify() {
        if canNotify {
            DispatchQueue.main.async(execute: { 
                NotificationCenter.default.post(name: NetworkUtil.NetworkReachableStateChanged, object: nil)
            })
        }
    }
}
