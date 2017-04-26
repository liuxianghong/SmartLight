//
//  EditeViewModel.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/26.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift

class EditeViewModel: UITableViewCell {

    fileprivate let bag: DisposeBag = DisposeBag()
    
    fileprivate weak var tableView: UITableView?
    
    fileprivate var deviceCells = [EditeLightCellViewModel]()
    
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, EditeLightCellViewModel>>()
    
    fileprivate func reloadDevices() {
        deviceCells.removeAll()
        let devices = DeviceManager.shareManager.bleDevices
        for item in devices {
            let model = EditeLightCellViewModel(device: item)
            deviceCells.append(model)
        }
    }
    
    func setTableView(tableView: UITableView) {
        reloadDevices()
        self.tableView = tableView
        dataSource.configureCell = {
            section, tableView, indexPath, _ in
            let cell = tableView.dequeueReusableCell(withIdentifier: EditeLightTableViewCell.reuseIdentifier, for: indexPath) as! EditeLightTableViewCell
            cell.tag = indexPath.row
            
            let model = section.sectionModels[indexPath.section].items[indexPath.row]
            cell.viewModel = model
            
            return cell
        }
        
        getModels().bind(to: tableView.rx.items(dataSource: dataSource)).addDisposableTo(bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak tableView](indexPath) in
            tableView?.deselectRow(at: indexPath, animated: true)
        }).addDisposableTo(bag)
    }
    
    fileprivate func getModels() -> Observable<[SectionModel<String, EditeLightCellViewModel>]> {
        return Observable.create { (observer) -> Disposable in
            let sections = [SectionModel(model: "", items: self.deviceCells)]
            observer.onNext(sections)
            observer.onCompleted()
            return Disposables.create {}
        }
    }
    
    func save() {
        guard let realm = try? Realm() else {return}
        try? realm.write {
            for devic in deviceCells {
                devic.updateName(devic.username.value)
            }
        }
    }

}
