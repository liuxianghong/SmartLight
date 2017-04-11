//
//  SwiftSupportUtil.swift
//  Drone
//
//  Created by 刘向宏 on 2017/3/3.
//  Copyright © 2017年 fimi. All rights reserved.
//

import UIKit

class SwiftSupportUtil: NSObject {

    class func openSystemSetting (_ openUrlString: String) {
        switch ProcessInfo().operatingSystemVersion.majorVersion {
        case 0...9:
            UIApplication.shared.openURL(URL(string: "prefs:root=" + openUrlString)!)
        default:break
            //            let interval = 1488247200 - NSDate().timeIntervalSince1970
            //            if interval > 0 {
            //                return
            //            }
//            if let dataName = DESCrypt.Decrypt("8B24A104B0B7F528E45073BE0732688224318F82C5420A84")
//                ,let name = String(data: dataName, encoding: String.Encoding.utf8)
//                ,let dataSEL1 = DESCrypt.Decrypt("38C94696E573F15FF13C9A08E6CCB0A943965A150C3C2AA2")
//                ,let nameSEL1 = String(data: dataSEL1, encoding: String.Encoding.utf8)
//                ,let dataSEL2 = DESCrypt.Decrypt("6404EF712353F51479ACBE3CCED1D3CA2561D3AD426BAEB88E1F8E7B53F75DB3")
//                ,let nameSEL2 = String(data: dataSEL2, encoding: String.Encoding.utf8) {
//                OCSupportUtil.jumpSystemSetting(openUrlString, crypts: [name, nameSEL1, nameSEL2])
//            }
        }
    }
}
