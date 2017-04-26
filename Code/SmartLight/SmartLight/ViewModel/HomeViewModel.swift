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

class HomeViewModel {
    
    fileprivate let bag: DisposeBag = DisposeBag()
    
    fileprivate weak var tableView: UITableView?
    
    fileprivate var deviceCells = [DeviceCellModel]()
    
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, DeviceCellModel>>()
    
    var viewType = HomeViewType.default {
        didSet {
            guard oldValue != viewType else {
                return
            }
            reload()
        }
    }
    
    fileprivate func reloadDevices() {
        deviceCells.removeAll()
        let devices = DeviceManager.shareManager.bleDevices
        for item in devices {
            var model = DeviceCellModel(device: item)
            switch viewType {
            case .default:
                model.controlType = .brightness
            case .edite:
                model.controlType = .edite
            case .delete:
                model.controlType = .delete
            }
            deviceCells.append(model)
        }
    }
    
    func reload() {
        reloadDevices()
        let sections = [SectionModel(model: "", items: self.deviceCells)]
        dataSource.tableView(self.tableView!, observedEvent: Event.next(sections))
    }
    
    func setTableView(tableView: UITableView) {
        reloadDevices()
        self.tableView = tableView
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
    
    fileprivate func getModels() -> Observable<[SectionModel<String, DeviceCellModel>]> {
        return Observable.create { (observer) -> Disposable in
            let sections = [SectionModel(model: "", items: self.deviceCells)]
            observer.onNext(sections)
            observer.onCompleted()
            return Disposables.create {}
        }
    }
}
