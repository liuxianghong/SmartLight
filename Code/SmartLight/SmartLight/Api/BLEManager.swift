//
//  BLEManager.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/13.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, MeshServiceApiDelegate {

    static let shareManager = BLEManager()
    
    fileprivate var manager: CBCentralManager!
    fileprivate var cperipheral: CBPeripheral?
    
    fileprivate let meshServiceApi = MeshServiceApi.sharedInstance() as! MeshServiceApi
    fileprivate let meshMTLCharacterUUID = "C4EDC000-9DAF-11E3-800A-00025B000B00"
    
    override fileprivate init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        
        meshServiceApi.setCentralManager(manager)
        meshServiceApi.meshServiceApiDelegate = self
        //meshServiceApi.setDeviceDiscoveryFilterEnabled(true)
        //meshServiceApi.setContinuousLeScanEnabled(true)
    }
    
    func didDiscoverDevice(_ uuid: CBUUID!, rssi: NSNumber!) {
        print(uuid)
    }
    
    func didAssociateDevice(_ deviceId: NSNumber!, deviceHash: Data!, meshRequestId: NSNumber!) {
        print(deviceId)
    }
    
    func isAssociatingDevice(_ deviceHash: Data!, stepsCompleted: NSNumber!, totalSteps: NSNumber!, meshRequestId: NSNumber!) {
        print("isAssociatingDevice",deviceHash,stepsCompleted,totalSteps,meshRequestId)
    }
    
    func setScannerEnabled(_ enabled: NSNumber!) {
        print(enabled)
        if enabled == 0 {
            manager.stopScan()
        } else {
            manager.scanForPeripherals(withServices: [CBUUID(string: "FEF1")], options: nil)
        }
    }
    
    func didUpdateAppearance(_ deviceHash: Data!, appearanceValue: Data!, shortName: Data!) {
        print(deviceHash)
    }
    
    func didTimeoutMessage(_ meshRequestId: NSNumber!) {
        print(meshRequestId)
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            manager.scanForPeripherals(withServices: [CBUUID(string: "FEF1")], options: nil)
            break
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral.name,advertisementData,RSSI);
//        let array = advertisementData["kCBAdvDataServiceUUIDs"] as! NSArray
//        for a in array {
//            print(a)//FEF1
//        }
        var enhancedAdvertismentData = advertisementData
        enhancedAdvertismentData[CSR_PERIPHERAL] = peripheral
        meshServiceApi.processMeshAdvert(enhancedAdvertismentData, rssi: RSSI)
        
        peripheral.delegate = self
        cperipheral = peripheral
        central.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnConnectionKey: true])
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect",peripheral)
        peripheral.discoverServices(nil)//[CBUUID(string: "FEF1")]
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        print("didDiscoverServices", services)
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil, let characteristics = service.characteristics else {
            return
        }
        
        print("didDiscoverCharacteristicsFor")
        
        meshServiceApi.connectBridge(peripheral, enableBridgeNotification: 1)
        for characteristic in characteristics {
            print(characteristic.uuid.uuidString)
            if characteristic.uuid.uuidString == meshMTLCharacterUUID {
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.discoverDescriptors(for: characteristic)
                print("meshMTLCharacterUUID",meshMTLCharacterUUID)
            }
            
        }
        
        //objc_setAssociatedObject(peripheral, "isBridgeService", true, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print(characteristic,characteristic.descriptors,error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor",error,characteristic.uuid)
        
        var advertisementData = [String: Any]()
        advertisementData[CBAdvertisementDataIsConnectable] = false
        advertisementData[CSR_NotifiedValueForCharacteristic] = characteristic.value
        advertisementData[CSR_didUpdateValueForCharacteristic] = characteristic
        advertisementData[CSR_PERIPHERAL] = peripheral
        meshServiceApi.processMeshAdvert(advertisementData, rssi: nil)
        
    }
    
    var bo = false
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateNotificationStateFor",error,characteristic.uuid)
        
        if !bo {
            bo = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                let hash = self.meshServiceApi.getDeviceHash(from: CBUUID(nsuuid: peripheral.identifier))
                print(hash!)
                self.meshServiceApi.associateDevice(hash, authorisationCode: nil)
            }

        }
        
    }
    
}
