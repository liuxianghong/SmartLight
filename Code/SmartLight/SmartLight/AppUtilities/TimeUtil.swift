//
//  TimeUtil.swift
//  Drone
//
//  Created by GuoLeon on 16/4/1.
//  Copyright © 2016年 fimi. All rights reserved.
//

import UIKit

class TimeUtil: NSObject {
    // MARK: 生成请求的时间戳, 当前时间加上六位
    class func requestTimestamp () -> String {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let nowString = dateFormatter.string(from: nowDate)
        let min: UInt32 = 10_000_000
        let max: UInt32 = 99_999_999
        let randomNumber = arc4random_uniform(max - min) + min
        return nowString + String(randomNumber)
    }
 }
