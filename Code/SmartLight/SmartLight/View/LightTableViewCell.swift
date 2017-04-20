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
    
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var slider: UISlider!
    @IBOutlet var temperatureImageView: UIImageView!
    @IBOutlet var colorImageView: UIImageView!
    
    var cellModel: DeviceCellModel? {
        didSet {
            guard let cellModel = cellModel else {
                return
            }
            nameLable.text = "\(cellModel.deviceID)"
            cellModel.device.update = { [weak self] (device) in
                self?.update(device: device)
            }
            
            self.update(device: cellModel.device)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        slider.setThumbImage(R.image.barN(), for: UIControlState.normal)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer { (long) in
            guard let long = long as? UILongPressGestureRecognizer else { return }
            if long.state == .began {
                self.leftLongClick()
            }
        }
        longPressGestureRecognizer.minimumPressDuration = 2
        leftButton.addGestureRecognizer(longPressGestureRecognizer)
        leftButton.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func update(device: BLEDevice) {
        guard let cellModel = cellModel
            , cellModel.device == device else {
            return
        }
        updateLeftButton()
    }
    
    fileprivate func updateLeftButton() {
        guard let cellModel = cellModel else {
            return
        }
        switch cellModel.controlType {
        case .delay:
            leftButton.setBackgroundImage(R.image.clock(), for: .normal)
        default:
            leftButton.setBackgroundImage(cellModel.device.power ? R.image.btnOffN() : R.image.btnOffS(), for: .normal)
        }
    }
    
    fileprivate func leftLongClick() {
        guard let cellModel = cellModel else {
            return
        }
        if cellModel.controlType != .delay {
            self.cellModel?.controlType = .delay
            updateLeftButton()
        }
    }

    @IBAction func powerClick() {
        guard let cellModel = cellModel else {
            return
        }
        switch cellModel.controlType {
        case .delay:
            self.cellModel?.controlType = .brightness
            updateLeftButton()
        default:
            cellModel.device.power = !(cellModel.device.power)
            DeviceSession.request((cellModel.device), command: .power) { (error, device) in
                DDLogDebug("powerClick request is: \(error) \(String(describing: device?.deviceId))")
            }
        }
    }
    
    @IBAction func lvealClick() {
        guard let cellModel = cellModel else {
            return
        }
        getHomeVC()?.deleteDevice((cellModel.device))
    }
    
    fileprivate func getHomeVC() -> HomeViewController? {
        var next = superview
        repeat {
            let nextResponder = next?.next
            if let nextResponder = nextResponder as? HomeViewController {
                return nextResponder
            }
            next = next?.superview
        } while (next != nil)
        return nil
    }
}
