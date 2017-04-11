//
//  HomeViewController.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/11.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var switchButton: UIButton!
    @IBOutlet var moreView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moreView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.bottom.equalToSuperview()
            ConstraintMaker.width.equalTo(SizeUtil.sidebarWidth)
            ConstraintMaker.left.equalTo(-SizeUtil.sidebarWidth)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moreClick(sender: UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            self.moreView.snp.updateConstraints { (ConstraintMaker) in
                ConstraintMaker.left.equalTo(0)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func bleClick(sender: UIButton) {
        
    }
    
    @IBAction func switchClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func editeClick(sender: UIButton) {
        
    }
    
    @IBAction func addClick(sender: UIButton) {
        
    }
    
    @IBAction func deleteClick(sender: UIButton) {
        
    }
//    override var prefersStatusBarHidden : Bool {
//        return true
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
