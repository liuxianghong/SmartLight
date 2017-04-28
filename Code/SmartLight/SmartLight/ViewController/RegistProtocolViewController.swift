//
//  RegistProtocolViewController.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/28.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit

class RegistProtocolViewController: UIViewController {

    @IBOutlet var registView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var protocolView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var registButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        registView.isHidden = true
        
        registButton.setTitle(R.string.localizable.loginRegist(), for: UIControlState.normal)
        backButton.setTitle(R.string.localizable.loginHaveAcount(), for: UIControlState.normal)
        titleLabel.text = R.string.localizable.loginJoinus()
        descriptionLabel.text = R.string.localizable.loginProtocolDes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registClick() {
        registView.isHidden = false
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
