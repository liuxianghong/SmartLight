//
//  ServerModel.swift
//  RXS
//
//  Created by 刘向宏 on 2017/4/24.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import Compression


class ServerResult: NSObject {
    var retCode: String?
    var retMsg: String?
}


class ServerLoginResult: ServerResult {
    var userId: String?
    var token: String?
    
    var loginName: String?
}

class ServerHomeDeviceResult: ServerResult {
    var totalCount: String?
    var homeDeviceList: [[String: String]]? {
        didSet {
            guard let homeDeviceList = homeDeviceList else {
                deviceList = nil
                return
            }
            deviceList = [ServerHomeLampResult]()
            for deviceJSON in homeDeviceList {
                if let device = ServerHomeLampResult.model(withJSON: deviceJSON) {
                    deviceList?.append(device)
                }
            }
        }
    }
    
    var deviceList: [ServerHomeLampResult]?
}

class ServerHomeLampResult: NSObject {
    var deviceId: String?
    var deviceName: String?
    var deviceLogoURL: String?
    var macAddress: String?
    var brandId: String?
    //var description: String?
    var power: String?
    var brightness: String?
    var tonal: String?
    var colorTemperature: String?
    var ra: String?
    var saturation: String?
    var redColor: String?
    var greenColor: String?
    var blueColor: String?
    var poweron: String?
    var timingOn: String?
    var startTime: String?
    var endTime: String?
    var randomOn: String?
    var delayOn: String?
    var delayTime: String?
}

extension String {
    func md5String() -> String{
        let cStr = self.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        buffer.deallocate(capacity: 16)
        return md5String as String
    }
}
