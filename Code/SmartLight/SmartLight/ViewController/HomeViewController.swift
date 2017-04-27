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
    fileprivate var loadingView = LoadingView()
    
    fileprivate let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moreView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.bottom.equalToSuperview()
            ConstraintMaker.width.equalTo(SizeUtil.sidebarWidth)
            ConstraintMaker.left.equalTo(-SizeUtil.sidebarWidth)
        }
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        loadingView.hide(false)
        
        tableView.tableFooterView = UIView()
        viewModel.setTableView(tableView: tableView)
        
        self.performSegue(withIdentifier: "login", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reload()
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
    
    func deleteDevice(_ device: BLEDevice) {
        
        let cancelItem = MessageBoxView.Item()
        cancelItem.title = R.string.localizable.no()
        cancelItem.font = UIFont.systemFont(ofSize: 15)
        cancelItem.normalColor = UIColor(white: 1, alpha: 1)
        cancelItem.highlightedColor = UIColor(white: 0.8, alpha: 1)
        cancelItem.backgroundColor = UIColor(hexString: "0D244C") ?? UIColor.clear
        cancelItem.action = { (view, _) -> Void in
            view.hideView(true)
        }
        
        let confirmItem = MessageBoxView.Item()
        confirmItem.title = R.string.localizable.yes()
        confirmItem.normalColor = UIColor(rgb: 0x0c234e)
        confirmItem.font = UIFont.systemFont(ofSize: 15)
        confirmItem.highlightedColor = UIColor(rgb: 0xfc7410).withAlphaComponent(0.8)
        confirmItem.action = { [weak self](view, _) -> Void in
            view.hideView(true) { (_) in
                self?.loadingView.show(true)
                DeviceSession.request(device
                    , command: .reset
                , expired: 10) { (error, dev) in
                    if error == .success {
                        DeviceManager.shareManager.deleteDevice(device: device)
                        self?.viewModel.reload()
                    }
                    self?.loadingView.hide(true)
                }
            }
        }
        
        let customizeLabel = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        let attributes = [NSParagraphStyleAttributeName: paragraphStyle
            , NSForegroundColorAttributeName: UIColor(rgb: 0x0c234e)
            , NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        customizeLabel.attributedText = NSMutableAttributedString(string: R.string.localizable.delete()
            , attributes: attributes
        )
        customizeLabel.textAlignment = .center
        customizeLabel.numberOfLines = 0
        
        MessageBoxView.showViewAddedTo(self.view
            , animated: true
            , customizeView: customizeLabel
            , buttons: [confirmItem, cancelItem]
        )
    }
    
    @IBAction func moreClick(sender: UIButton) {
        showSide(show: true)
    }
    
    @IBAction func bleClick(sender: UIButton) {
        BLEManager.shareManager.startScan()
    }
    
    @IBAction func switchClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func editeClick(sender: UIButton) {
        
    }
    
    @IBAction func addClick(sender: UIButton) {
        
    }
    
    @IBAction func deleteClick(sender: UIButton) {
        viewModel.viewType = (viewModel.viewType == .delete) ? .default : .delete
    }

}
