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
            cell.lable?.text = model.title
            
            return cell
        }
        
        getUsers().bind(to: tableView.rx.items(dataSource: dataSource)).addDisposableTo(bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
            let model = self.dataSource.sectionModels[indexPath.section].items[indexPath.row]
            self.performSegue(withIdentifier: model.identifier, sender: nil)
        }).addDisposableTo(bag)
//        tableView.rx_setDelegate(self).addDisposableTo(bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeClick() {
        homeVC?.showSide(show: false)
    }
    
    var homeVC: HomeViewController? {
        return self.parent as? HomeViewController
    }
    
    func getUsers() -> Observable<[SectionModel<String, MoreModel>]> {
        return Observable.create { (observer) -> Disposable in
            
            
            let models = [MoreModel(title: R.string.localizable.moreWifisetting(), identifier: "settingIdentifier")
                        , MoreModel(title: R.string.localizable.moreHowToUse(), identifier: "useIdentifier")
                        , MoreModel(title: R.string.localizable.moreAbout(), identifier: "aboutIdentifier")]
            
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
