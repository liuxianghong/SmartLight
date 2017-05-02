//
//  ForgetViewController.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/27.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import MBProgressHUD

class ForgetViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var titleLable: UILabel!
    
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var pwTF: UITextField!
    @IBOutlet var codeTF: UITextField!
    @IBOutlet var codeButton: UIButton!
    @IBOutlet var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLable.text = R.string.localizable.loginForget()
        
        nameTF.placeholder = R.string.localizable.loginInputEmail()
        pwTF.placeholder = R.string.localizable.loginInputPassword()
        codeTF.placeholder = R.string.localizable.loginCode()
        okButton.setTitle(R.string.localizable.oK(), for: UIControlState.normal)
        codeButton.setTitle(R.string.localizable.loginSendCode(), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okClick() {
        
        let hud = MBProgressHUD.showAdded(to: self.view.window!, animated: true)
        let name = nameTF.text ?? ""
        let pw = pwTF.text ?? ""
        let code = codeTF.text ?? ""
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
        
        if code.isEmpty {
            hud.mode = .text
            hud.label.text = R.string.localizable.loginInputCode()
            hud.hide(animated: true, afterDelay: 1.5)
            return
        }
        
        ServerApi.forget(loginName: name, password: pw, captcha: code) { (reslut) in
            if let retCode = reslut.retCode, retCode == "0" {
                hud.hide(animated: true)
                self.navigationController?.popViewController(animated: true)
            } else {
                hud.mode = .text
                hud.label.text = reslut.retMsg ?? R.string.localizable.loginFaile()
                hud.hide(animated: true, afterDelay: 1.5)
            }
        }
    }
    
    @IBAction func codeClick() {
        let hud = MBProgressHUD.showAdded(to: self.view.window!, animated: true)
        let name = nameTF.text ?? ""
        if name.isEmpty {
            hud.mode = .text
            hud.label.text = R.string.localizable.loginInputEmail()
            hud.hide(animated: true, afterDelay: 1.5)
            return
        }
        
        ServerApi.getCaptcha(mobile: name) { (reslut) in
            if let retCode = reslut.retCode, retCode == "0" {
                self.codeButton.setTitle(R.string.localizable.loginReSendCode(), for: UIControlState.normal)
                hud.hide(animated: true)
            } else {
                hud.mode = .text
                hud.label.text = reslut.retMsg ?? R.string.localizable.loginFaile()
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
