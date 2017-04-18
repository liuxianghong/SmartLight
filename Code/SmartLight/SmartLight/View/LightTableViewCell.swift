//
//  LightTableViewCell.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/13.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit

class LightTableViewCell: UITableViewCell {

    static let reuseIdentifier = "LightCellReuseIdentifier"
    
    @IBOutlet var nameLable: UILabel!
    
    var cellModel = DeviceCellModel() {
        didSet {
            guard oldValue.deviceID != cellModel.deviceID else {
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

}
