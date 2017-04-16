//
//  MoreViewController.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/11.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct MoreModel {
    var title: String
    var identifier: String
}

class MoreViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MoreModel>>()
    let bag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        
        dataSource.configureCell = {
            section, tableView, indexPath, _ in
            let cell = tableView.dequeueReusableCell(withIdentifier: SideTableViewCell.reuseIdentifier, for: indexPath) as! SideTableViewCell
            cell.tag = indexPath.row
            
            let model = section.sectionModels[indexPath.section].items[indexPath.row]
            cell.textLabel?.text = model.title
            
            return cell
        }
        
        getUsers().bind(to: tableView.rx.items(dataSource: dataSource)).addDisposableTo(bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).addDisposableTo(bag)
//        tableView.rx_setDelegate(self).addDisposableTo(bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeClick() {
        UIView.animate(withDuration: 0.5) {
            self.view.superview?.snp.updateConstraints { (ConstraintMaker) in
                ConstraintMaker.left.equalTo(-SizeUtil.sidebarWidth)
            }
            self.view.superview?.superview?.layoutIfNeeded()
        }
    }
    
    
    func getUsers() -> Observable<[SectionModel<String, MoreModel>]> {
        return Observable.create { (observer) -> Disposable in
            
            
            let models = [MoreModel(title: "setting", identifier: "")
                ,MoreModel(title: "about", identifier: "")]
            
            let section = [SectionModel(model: "", items: models)]
            
            observer.onNext(section)
            observer.onCompleted()
            return Disposables.create {
                
            }
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
