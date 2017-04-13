//
//  BLEManager.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/13.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    static let shareManager = BLEManager()
    
    fileprivate var manager: CBCentralManager!
    fileprivate var cperipheral: CBPeripheral?
    
    override fileprivate init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            
            manager.scanForPeripherals(withServices: [CBUUID(string: "FEF1")], options: nil)
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral.name,advertisementData,RSSI);
        let array = advertisementData["kCBAdvDataServiceUUIDs"] as! NSArray
        for a in array {
            print(a)//FEF1
        }
        peripheral.delegate = self
        cperipheral = peripheral
        central.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnConnectionKey: true])
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect",peripheral)
        peripheral.discoverServices(nil)//[CBUUID(string: "FEF1")]
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let service = peripheral.services?.first!
        peripheral.discoverCharacteristics(nil, for: service!)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for chat in (service.characteristics)! {
            peripheral.discoverDescriptors(for: chat)
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print(characteristic,characteristic.descriptors,error)
    }
}
