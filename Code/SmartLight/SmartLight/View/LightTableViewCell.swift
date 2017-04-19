//
//  LightTableViewCell.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/13.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import CocoaLumberjack

class LightTableViewCell: UITableViewCell {

    static let reuseIdentifier = "LightCellReuseIdentifier"
    
    @IBOutlet var nameLable: UILabel!
    
    var cellModel: DeviceCellModel? {
        didSet {
            guard let cellModel = cellModel else {
                return
            }
            nameLable.text = "\(cellModel.deviceID)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var power = false
    @IBAction func powerClick() {
        cellModel?.device.power = !(cellModel?.device.power)!
        DeviceSession.request((cellModel?.device)!, command: .power) { (error, device) in
            DDLogDebug("powerClick request is: \(error) \(String(describing: device?.deviceId))")
        }
    }
}
