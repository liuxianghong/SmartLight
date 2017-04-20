//
//  ModelDefine.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/17.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct MoreModel {
    var title: String
    var identifier: String
}


struct DeviceCellModel {
    
    var deviceID: Int {
        return Int(deviceIn.deviceId)
    }
    var controlType = DeviceControlType.brightness
    
    var device: BLEDevice {
        return deviceIn
    }
    
    fileprivate var deviceIn: BLEDevice
    
    init(device: BLEDevice) {
        self.deviceIn = device
    }
}

enum DeviceControlType {
    case brightness
    case edite
    case clolorTemp
    case timer
    case delay
    case delete
    case color
}

class BaseViewModel: NSObject {
    let disposeBag = DisposeBag()
    var refreshStatus = Variable.init(RefreshStatus.InvalidData)
    var dataSource = Variable.init([DeviceCellModel]())
}

enum RefreshStatus: Int {
    case DropDownSuccess // 下拉成功
    case PullSuccessHasMoreData // 上拉，还有更多数据
    case PullSuccessNoMoreData // 上拉，没有更多数据
    case InvalidData // 无效的数据
}
