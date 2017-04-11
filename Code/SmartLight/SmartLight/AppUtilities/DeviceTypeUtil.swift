//
//  DeviceTypeUtil.swift
//  Drone
//
//  Created by FengQingYang on 16/5/3.
//  Copyright © 2016年 fimi. All rights reserved.
//

import UIKit

class DeviceTypeUtil: NSObject {
    
    // MARK: 获得当前设备的唯一标示符号
    class func deviceTypeForPhone () -> String {
        let string = "\(UIDevice.deviceModel)"
        return string.replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "").lowercased()
    }
}
