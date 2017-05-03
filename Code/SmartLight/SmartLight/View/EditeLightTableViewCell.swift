//
//  EditeLightTableViewCell.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/26.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditeLightTableViewCell: UITableViewCell {

    static let reuseIdentifier = "EditeLightCellReuseIdentifier"
    
    @IBOutlet var nameLable: UILabel!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var nameTF: UITextField!
    
    
    
    fileprivate var subscription: Disposable?
    
    var viewModel: EditeLightCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            nameLable.text = viewModel.device.name
            nameTF.text = viewModel.username.value
            subscription?.dispose()
            subscription = nameTF.rx.text.orEmpty
                .bind(to: viewModel.username)
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

    @IBAction func powerClick() {
    }
}
