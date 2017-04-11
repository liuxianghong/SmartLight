//
//  DeviceSize.swift
//  Drone
//
//  Created by GuoLeon on 15/12/21.
//  Copyright © 2015年 fimi. All rights reserved.
//

import UIKit

class DeviceSize: NSObject {
    
    class var customButtonHeight: CGFloat {
        get {
            return 42.0
        }
    }
    
    class func deviceWidth() -> CGFloat {
        
        return UIScreen.main.bounds.width
    }
    
    class func deviceHeight() -> CGFloat {
        
        return UIScreen.main.bounds.height
        
    }
    
    class func isIPhone4s(_ isLandscape: Bool) -> Bool {
        if isLandscape {
            return deviceHeight() == 320 && deviceWidth() == 480
        } else {
            return deviceHeight() == 480 && deviceWidth() == 320
            
        }
    }
    
    class func isIPhone5(_ isLandscape: Bool) -> Bool {
        if isLandscape {
            return deviceHeight() == 320 && deviceWidth() == 568
        } else {
            return deviceHeight() == 568 && deviceWidth() == 320
            
        }
    }
    
    class func isIPhone6(_ isLandscape: Bool) -> Bool {
        if isLandscape {
            return deviceHeight() == 375 && deviceWidth() == 667
        } else {
            return deviceHeight() == 667 && deviceWidth() == 375
            
        }
    }
    
    class func isIPhone6Plus(_ isLandscape:Bool) -> Bool {
        if isLandscape {
            return deviceHeight() == 414 && deviceWidth() == 736
        } else {
            return deviceHeight() == 736 && deviceWidth() == 414
            
        }
    }
    
    var isSettingPop = false
    
    //var homeViewType: RootHomeMode = .Account
    // 缺省单实例对象
    static let sharedInstance = DeviceSize()
    
    fileprivate override init() {
        super.init()
    }
    
}

