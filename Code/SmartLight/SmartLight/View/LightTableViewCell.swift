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
    
    fileprivate var checkTimer: Timer?
    
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
        
        let longPressLeft = UILongPressGestureRecognizer { (long) in
            guard let long = long as? UILongPressGestureRecognizer else { return }
            if long.state == .began {
                self.leftLongClick()
            }
        }
        longPressLeft.minimumPressDuration = 2
        leftButton.addGestureRecognizer(longPressLeft)
        leftButton.isUserInteractionEnabled = true
        
        let longPressRight = UILongPressGestureRecognizer { (long) in
            guard let long = long as? UILongPressGestureRecognizer else { return }
            if long.state == .began {
                self.rightLongClick()
            }
        }
        longPressRight.minimumPressDuration = 2
        rightButton.addGestureRecognizer(longPressRight)
        rightButton.isUserInteractionEnabled = true
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
        updateUI()
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
    
    fileprivate func updateSlider() {
    }
    
    fileprivate func updateRightButton() {
        guard let cellModel = cellModel else {
            return
        }
        
        rightButton.isHidden = false
        rightButton.layer.removeAllAnimations()
        switch cellModel.controlType {
        case .timer:
            rightButton.setBackgroundImage(R.image.time(), for: .normal)
        case .clolorTemp:
            rightButton.setBackgroundImage(R.image.colorTemperature(), for: .normal)
        case .delay:
            rightButton.isHidden = true
        case .delete:
            rightButton.setBackgroundImage(R.image.delete(), for: .normal)
            
            let anim = CAKeyframeAnimation(keyPath: "transform.rotation")
            anim.values = [(-3 / 180 * Double.pi), (3 / 180 * Double.pi),(-3 / 180 * Double.pi)]
            
            anim.repeatCount = Float(MAX_CANON)
            anim.duration = 0.2
            anim.autoreverses = true
            rightButton.layer.add(anim, forKey: nil)
//            let keyframeAni = CAKeyframeAnimation(keyPath: "transform.rotation")
//            keyframeAni.duration = 0.2
//            keyframeAni.repeatCount = 10000;
//            let k = 360.0 * (Double.pi * 2)
//            keyframeAni.values = [5 / k, 0, -5 / k, 0, 5 / k]
//            rightButton.layer.add(keyframeAni, forKey: "keyframeAni")
        default:
            rightButton.setBackgroundImage(R.image.colorTemperature(), for: .normal)
        }
    }
    
    fileprivate func updateUI() {
        updateLeftButton()
        updateRightButton()
        updateSlider()
    }
    
    fileprivate func leftLongClick() {
        guard let cellModel = cellModel else {
            return
        }
        if cellModel.controlType != .delay {
            self.cellModel?.controlType = .delay
            updateUI()
            startTimer()
        }
    }
    
    fileprivate func rightLongClick() {
        guard let cellModel = cellModel else {
            return
        }
        
        switch cellModel.controlType {
        case .timer:
            break
        default:
            self.cellModel?.controlType = .timer
            updateUI()
            startTimer()
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
            updateSlider()
            stopTimer()
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
        
        switch cellModel.controlType {
        case .timer:
            self.cellModel?.controlType = .brightness
            updateRightButton()
            updateSlider()
            stopTimer()
        case .brightness:
            self.cellModel?.controlType = .clolorTemp
            updateRightButton()
            updateSlider()
        case .clolorTemp:
            self.cellModel?.controlType = .brightness
            updateRightButton()
            updateSlider()
        case .delete:
            getHomeVC()?.deleteDevice((cellModel.device))
        default:
            break
        }
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
    
    fileprivate func stopTimer() {
        checkTimer?.invalidate()
        checkTimer = nil
    }
    
    fileprivate func startTimer() {
        stopTimer()
        checkTimer = Timer.scheduledTimer(timeInterval: 2
            , target: self
            , selector: #selector(checkTimerMethod(_:))
            , userInfo: nil
            , repeats: true
        )
    }
    
    func checkTimerMethod(_ timer: Timer) {
        self.cellModel?.controlType = .brightness
        updateUI()
        stopTimer()
    }
}
