//
//  LoginViewController.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/27.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameTF: UITextField!
    @IBOutlet var pwTF: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var forgetButton: UIButton!
    @IBOutlet var registButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameTF.placeholder = R.string.localizable.loginInputEmail()
        pwTF.placeholder = R.string.localizable.loginInputPassword()
        loginButton.setTitle(R.string.localizable.loginLogin(), for: UIControlState.normal)
        
        let forget = R.string.localizable.loginRegist()
        let str = NSMutableAttributedString(string: forget)
        
        str.addAttributes([NSUnderlineStyleAttributeName: 1, NSForegroundColorAttributeName: UIColor.darkText], range: NSRange(location: 0, length: (forget as NSString).length))
        registButton.setAttributedTitle(str, for: UIControlState.normal)
        forgetButton.setTitle(R.string.localizable.loginForget(), for: UIControlState.normal)
        
        nameTF.text = "178483623@qq.com"
        pwTF.text = "111"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClick() {
        let hud = MBProgressHUD.showAdded(to: self.view.window!, animated: true)
        let name = nameTF.text ?? ""
        let pw = pwTF.text ?? ""
        if name.isEmpty {
            hud.mode = .text
            hud.label.text = R.string.localizable.loginInputEmail()
            hud.hide(animated: true, afterDelay: 1.5)
            return
        }
        
        if pw.isEmpty {
            hud.mode = .text
            hud.label.text = R.string.localizable.loginInputPassword()
            hud.hide(animated: true, afterDelay: 1.5)
            return
        }
        
        ServerApi.login(loginName: name, password: pw) { (reslut) in
            if let retCode = reslut.retCode, retCode == "0" {
                hud.hide(animated: true)
                ServerApi.userId = reslut.userId
                ServerApi.token = reslut.token
                self.navigationController?.popViewController(animated: true)
            } else {
                hud.mode = .text
                hud.label.text = reslut.retMsg ?? R.string.localizable.loginLoginfaile()
                hud.hide(animated: true, afterDelay: 1.5)
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
