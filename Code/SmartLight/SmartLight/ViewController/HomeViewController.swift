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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moreClick(sender: UIButton) {
        
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
