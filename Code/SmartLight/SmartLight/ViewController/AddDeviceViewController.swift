//
//  AddDeviceViewController.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/17.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit

class AddDeviceViewController: UIViewController {

    @IBOutlet var titleLable: UILabel!
    
    @IBOutlet var stopButton: UIButton!
    
    @IBOutlet var stateImageView: UIImageView!
    
    @IBOutlet var stateLable: UILabel!
    
    fileprivate var request: DeviceSession?
    
    fileprivate var isAdding = false {
        didSet {
            request = nil
            if isAdding {
                stopButton.setTitle(R.string.localizable.addStop(), for: UIControlState.normal)
                stateLable.text = R.string.localizable.addConnecting()
                stateLable.textColor = UIColor(colorLiteralRed: 0, green: 0xa4 / 255.0, blue: 0xef / 255.0, alpha: 1)
                stateImageView.isHighlighted = false
            } else {
                stopButton.setTitle(R.string.localizable.addTryAgin(), for: UIControlState.normal)
                stateLable.text = R.string.localizable.addCanotconnect()
                stateLable.textColor = UIColor(colorLiteralRed: 0xb3 / 255.0, green: 0xb3 / 255.0, blue: 0xb3 / 255.0, alpha: 1)
                stateImageView.isHighlighted = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLable.text = R.string.localizable.addTitle()
        isAdding = true
        let image = R.image.wifi()?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        stateImageView.highlightedImage = image
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        beginAdd()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func beginAdd() {
        request = DeviceSession.request(BLEDevice()
            , command: .discovery
        , expired: 10) { [weak self](error, device) in
            if error == .success {
                self?.addDevice(device: device!)
            } else {
                self?.addResult(bo: false)
            }
        }
    }
    
    fileprivate func addDevice(device: BLEDevice) {
        request = DeviceSession.request(device
        , command: .associate
        , expired: 20) { [weak self](error, device) in
            if error == .success {
                DeviceManager.shareManager.addDevice(device: device!)
            }
            self?.addResult(bo: error == .success)
        }
    }
    
    fileprivate func addResult(bo: Bool) {
        if bo {
            self.backClick()
        } else {
            isAdding = false
        }
    }
    
    @IBAction func backClick() {
        request?.stop()
        request = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func stopClick() {
        if isAdding {
            self.backClick()
        } else {
            beginAdd()
            isAdding = true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
