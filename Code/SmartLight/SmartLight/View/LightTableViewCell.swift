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
    @IBOutlet var minvalueLabel: UILabel!
    @IBOutlet var maxvalueLabel: UILabel!
    @IBOutlet var currentvalueLabel: UILabel!
    @IBOutlet var rightNameLabel: UILabel!
    
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
        slider.setThumbImage(R.image.barN(), for: UIControlState.highlighted)
        slider.maximumValue = 255
        slider.minimumValue = 1
        
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
        guard let cellModel = cellModel else {
            return
        }
        slider.isHidden = cellModel.controlType == .edite
        switch cellModel.controlType {
        default:
            break
        }
    }
    
    fileprivate func updateRightButton() {
        guard let cellModel = cellModel else {
            return
        }
        
        rightButton.isHidden = false
        
        temperatureImageView.isHidden = true
        colorImageView.isHidden = true
        minvalueLabel.isHidden = true
        maxvalueLabel.isHidden = true
        currentvalueLabel.isHidden = true
        rightNameLabel.isHidden = true
        
//        rightButton.layer.removeAllAnimations()
        switch cellModel.controlType {
        case .timer:
            rightButton.setBackgroundImage(R.image.time(), for: .normal)
            minvalueLabel.isHidden = false
            maxvalueLabel.isHidden = false
            currentvalueLabel.isHidden = false
            rightNameLabel.text = R.string.localizable.timer()
            minvalueLabel.text = "1"
            maxvalueLabel.text = "120"
            rightNameLabel.isHidden = false
        case .color:
            rightButton.setBackgroundImage(R.image.colorTemperature(), for: .normal)
            rightNameLabel.text = R.string.localizable.color()
            rightNameLabel.isHidden = false
            colorImageView.isHidden = false
        case .clolorTemp:
            rightButton.setBackgroundImage(R.image.colorTemperature(), for: .normal)
            rightNameLabel.text = R.string.localizable.colorTemperature()
            rightNameLabel.isHidden = false
            temperatureImageView.isHidden = false
        case .brightness:
            rightButton.setBackgroundImage(R.image.colorTemperature(), for: .normal)
            rightNameLabel.text = R.string.localizable.brightness()
            rightNameLabel.isHidden = false
        case .delay:
            rightButton.isHidden = true
            minvalueLabel.isHidden = false
            maxvalueLabel.isHidden = false
            currentvalueLabel.isHidden = false
            minvalueLabel.text = "1"
            maxvalueLabel.text = "90"
        case .delete:
            rightButton.setBackgroundImage(R.image.delete(), for: .normal)
        case .deleteSure:
            rightButton.setBackgroundImage(R.image.deleteSure(), for: .normal)
        case .edite:
            break
            
//            let anim = CAKeyframeAnimation(keyPath: "transform.rotation")
//            anim.values = [(-3 / 180 * Double.pi), (3 / 180 * Double.pi),(-3 / 180 * Double.pi)]
//            
//            anim.repeatCount = Float(MAX_CANON)
//            anim.duration = 0.2
//            anim.autoreverses = true
//            rightButton.layer.add(anim, forKey: nil)
//            let keyframeAni = CAKeyframeAnimation(keyPath: "transform.rotation")
//            keyframeAni.duration = 0.2
//            keyframeAni.repeatCount = 10000;
//            let k = 360.0 * (Double.pi * 2)
//            keyframeAni.values = [5 / k, 0, -5 / k, 0, 5 / k]
//            rightButton.layer.add(keyframeAni, forKey: "keyframeAni")
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
        
        cellModel.device.color = UIColor(red: 0.3, green: 0.1, blue: 0.1, alpha: 0.2)
        cellModel.device.level = 255
        DeviceSession.request(cellModel.device, command: .color) { (error, device) in
            print(error)
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
            self.cellModel?.controlType = .color
            updateRightButton()
            updateSlider()
        case .color:
            self.cellModel?.controlType = .brightness
            updateRightButton()
            updateSlider()
        case .delete:
            self.cellModel?.controlType = .deleteSure
            updateRightButton()
        case .deleteSure:
            getHomeVC()?.deleteDevice((cellModel.device))
        default:
            break
        }
    }
    
    @IBAction func sliderClick() {
        print("sliderClick")
        guard let cellModel = cellModel else {
            return
        }
        switch cellModel.controlType {
        case .delay, .timer:
            startTimer()
        default:
            break
        }
    }
    
    @IBAction func sliderClickInside() {
        sliderSet()
    }
    
    @IBAction func siderClickOutside() {
        sliderSet()
    }
    
    fileprivate func sliderSet() {
        guard let cellModel = cellModel else {
            return
        }
        cellModel.device.level = UInt8(slider.value)
        DeviceSession.request(cellModel.device, command: .level) { (error, device) in
            //DDLogDebug("level: \(device?.level)")
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
