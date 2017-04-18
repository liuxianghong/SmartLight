//
//  HomeViewModel.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/17.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum HomeViewType {
    case `default`
    case delete
    case edite
}

class HomeViewModel {
    
    fileprivate let bag: DisposeBag = DisposeBag()
    
    fileprivate weak var tableView: UITableView?
    
    fileprivate var deviceCells = [DeviceCellModel]()
    
    var viewType = HomeViewType.default {
        didSet {
            guard oldValue != viewType else {
                return
            }
            self.tableView?.reloadData()
        }
    }
    
    func setTableView(tableView: UITableView) {
        self.tableView = tableView
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, DeviceCellModel>>()
        dataSource.configureCell = {
            section, tableView, indexPath, _ in
            let cell = tableView.dequeueReusableCell(withIdentifier: LightTableViewCell.reuseIdentifier, for: indexPath) as! LightTableViewCell
            cell.tag = indexPath.row
            
            let model = section.sectionModels[indexPath.section].items[indexPath.row]
            cell.cellModel = model
            
            return cell
        }
        
        getModels().bind(to: tableView.rx.items(dataSource: dataSource)).addDisposableTo(bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak tableView](indexPath) in
            tableView?.deselectRow(at: indexPath, animated: true)
        }).addDisposableTo(bag)
    }
    
    func getModels() -> Observable<[SectionModel<String, DeviceCellModel>]> {
        return Observable.create { (observer) -> Disposable in
            let sections = [SectionModel(model: "", items: self.deviceCells)]
            observer.onNext(sections)
            observer.onCompleted()
            return Disposables.create {}
        }
    }
}
