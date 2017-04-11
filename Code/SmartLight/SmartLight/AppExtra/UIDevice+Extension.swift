//
//  UIDeviceExtension.swift
//  Drone
//
//  Created by BC600 on 16/4/5.
//  Copyright © 2016年 fimi. All rights reserved.
//

import Foundation
import UIKit

public enum DeviceModel: String {
    case Simulator      = "Simulator/Sandbox"
    case iPodTouch1     = "iPodTouch1"
    case iPodTouch2     = "iPodTouch2"
    case iPodTouch3     = "iPodTouch3"
    case iPodTouch4     = "iPodTouch4"
    case iPodTouch5     = "iPodTouch5"
    case iPodTouch6     = "iPodTouch6"
    case iPod1          = "iPod 1"
    case iPod2          = "iPod 2"
    case iPod3          = "iPod 3"
    case iPod4          = "iPod 4"
    case iPod5          = "iPod 5"
    case iPad2          = "iPad 2"
    case iPad3          = "iPad 3"
    case iPad4          = "iPad 4"
    case iPhone4        = "iPhone 4"
    case iPhone4S       = "iPhone 4S"
    case iPhone5        = "iPhone 5"
    case iPhone5S       = "iPhone 5S"
    case iPhone5C       = "iPhone 5C"
    case iPadMini1      = "iPad Mini 1"
    case iPadMini2      = "iPad Mini 2"
    case iPadMini3      = "iPad Mini 3"
    case iPadMini4      = "iPadMini4"
    case iPadAir1       = "iPad Air 1"
    case iPadAir2       = "iPad Air 2"
    case iPadPro        = "iPadPro"
    case iPhone6        = "iPhone 6"
    case iPhone6plus    = "iPhone 6 Plus"
    case iPhone6S       = "iPhone 6S"
    case iPhone6Splus   = "iPhone 6S Plus"
    case iPhoneSE       = "iPhoneSE"
    case iPhone7        = "iPhone 7"
    case iPhone7Plus    = "iPhone 7 Plus"
    case Unrecognized   = "unrecognized"
}

extension UIDevice {
    public class var deviceModel: DeviceModel {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0,  count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        
        func mapIdentifierToDevice(_ identifier: String) -> DeviceModel {
            switch identifier {
            case "iPod1,1":                                 return .iPodTouch1
            case "iPod2,1":                                 return .iPodTouch2
            case "iPod3,1":                                 return .iPodTouch3
            case "iPod4,1":                                 return .iPodTouch4
            case "iPod5,1":                                 return .iPodTouch5
            case "iPod7,1":                                 return .iPodTouch6
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return .iPhone4
            case "iPhone4,1":                               return .iPhone4S
            case "iPhone5,1", "iPhone5,2":                  return .iPhone5
            case "iPhone5,3", "iPhone5,4":                  return .iPhone5C
            case "iPhone6,1", "iPhone6,2":                  return .iPhone5S
            case "iPhone7,2":                               return .iPhone6
            case "iPhone7,1":                               return .iPhone6plus
            case "iPhone8,1":                               return .iPhone6S
            case "iPhone8,2":                               return .iPhone6Splus
            case "iPhone8,3", "iPhone8,4":                  return .iPhoneSE
            case "iPhone9,1":                               return .iPhone7
            case "iPhone9,2":                               return .iPhone7Plus
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return .iPad2
            case "iPad3,1", "iPad3,2", "iPad3,3":           return .iPad3
            case "iPad3,4", "iPad3,5", "iPad3,6":           return .iPad4
            case "iPad4,1", "iPad4,2", "iPad4,3":           return .iPadAir1
            case "iPad5,3", "iPad5,4":                      return .iPadAir2
            case "iPad2,5", "iPad2,6", "iPad2,7":           return .iPadMini1
            case "iPad4,4", "iPad4,5", "iPad4,6":           return .iPadMini2
            case "iPad4,7", "iPad4,8", "iPad4,9":           return .iPadMini3
            case "iPad5,1", "iPad5,2":                      return .iPadMini4
            case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return .iPadPro
            case "i386", "x86_64":                          return .Simulator
            default:                                        return .Unrecognized
            }
        }
        return mapIdentifierToDevice(String(cString: machine))
    }
}
