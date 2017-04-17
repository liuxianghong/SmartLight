//
//  SideTableViewCell.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/13.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit

class SideTableViewCell: UITableViewCell {

    static let reuseIdentifier = "SideCellReuseIdentifier"
    
    @IBOutlet var lable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
