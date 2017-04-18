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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLable.text = R.string.localizable.addTitle()
        stopButton.setTitle(R.string.localizable.addStop(), for: UIControlState.normal)
        stateLable.text = R.string.localizable.addStop()
        stateLable.textColor = UIColor(colorLiteralRed: 0, green: 0xa4 / 255.0, blue: 0xef / 255.0, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BLEManager.shareManager.setDiscoveryDevice(discovery: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BLEManager.shareManager.setDiscoveryDevice(discovery: false)
    }
    
    @IBAction func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func stopClick() {
        self.navigationController?.popViewController(animated: true)
        BLEManager.shareManager.setDiscoveryDevice(discovery: false)
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
