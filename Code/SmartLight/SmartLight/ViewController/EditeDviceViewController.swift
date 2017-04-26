//
//  EditeDviceViewController.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/26.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit

class EditeDviceViewController: UIViewController {

    @IBOutlet var titleLable: UILabel!
    
    @IBOutlet var stopButton: UIButton!
    
    @IBOutlet var tableView: UITableView!
    
    fileprivate let viewModel = EditeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLable.text = R.string.localizable.addTitle()
        
        tableView.tableFooterView = UIView()
        viewModel.setTableView(tableView: tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func stopClick() {
        viewModel.save()
        self.navigationController?.popViewController(animated: true)
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
