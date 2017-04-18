//
//  HomeViewController.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/11.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: UIViewController {

    @IBOutlet var switchButton: UIButton!
    @IBOutlet var moreView: UIView!
    @IBOutlet var tableView: UITableView!
    
    fileprivate let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moreView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.bottom.equalToSuperview()
            ConstraintMaker.width.equalTo(SizeUtil.sidebarWidth)
            ConstraintMaker.left.equalTo(-SizeUtil.sidebarWidth)
        }
        
        tableView.tableFooterView = UIView()
        viewModel.setTableView(tableView: tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSide(show: Bool) {
        let width = show ? CGFloat(0) : -SizeUtil.sidebarWidth
        UIView.animate(withDuration: 0.5) {
            self.moreView.snp.updateConstraints { (ConstraintMaker) in
                ConstraintMaker.left.equalTo(width)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func moreClick(sender: UIButton) {
        showSide(show: true)
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

}
