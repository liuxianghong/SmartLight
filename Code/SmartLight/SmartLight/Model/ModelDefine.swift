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
    var deviceID = Int(0)
    var controlType = DeviceControlType.default
}

enum DeviceControlType {
    case `default`
    case light
    case temperature
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
