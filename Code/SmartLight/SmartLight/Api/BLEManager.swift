//
//  BLEManager.swift
//  SmartLight
//
//  Created by 刘向宏 on 2017/4/13.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import CoreBluetooth

enum NoticeCmd: String {
    case discover = "didDiscoverDevice"
    case associate = "didAssociateDevice"
    case associating = "isAssociatingDevice"
    case appearanceating = "isAssocididUpdateAppearanceatingDevice"
    case timeout = "didTimeoutMessage"
    case powerState = "didGetPowerState"
    case lightState = "didGetLightState"
    case reset = "didResetDevice"
}

class BLEManager: NSObject {

    static let shareManager = BLEManager()
    
    static let NOTICE_RECV_MESSAGE = NSNotification.Name(rawValue: "DEV_NOTICE_RECV_MESSAGE")
    
    static let bleQueue = DispatchQueue(label: "bleQueue", attributes: [])
    
    fileprivate var manager: CBCentralManager!
    fileprivate var cperipheral: CBPeripheral?
    
    fileprivate let meshServiceApi = MeshServiceApi.sharedInstance() as! MeshServiceApi
    fileprivate let powerModelApi = PowerModelApi.sharedInstance() as! PowerModelApi
    fileprivate let lightModelApi = LightModelApi.sharedInstance() as! LightModelApi
    fileprivate let configModelApi = ConfigModelApi.sharedInstance() as! ConfigModelApi
    fileprivate let meshMTLCharacterUUID = "C4EDC000-9DAF-11E3-800A-00025B000B00"
    
    override fileprivate init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        meshServiceApi.setCentralManager(manager)
        meshServiceApi.meshServiceApiDelegate = self
        
        powerModelApi.powerModelApiDelegate = self
        lightModelApi.lightModelApiDelegate = self
        configModelApi.configModelApiDelegate = self
    }
    
    func broadcastMessage(_ msg: [String: Any]) {
        print("broadcastMessage: ",msg.description)
        DispatchQueue.main.async { 
            NotificationCenter.default.post(name: BLEManager.NOTICE_RECV_MESSAGE
                , object: self
                , userInfo: ["recvMsg": msg]
            )
        }
    }
    
    func startScan() {
        manager.stopScan()
        manager.scanForPeripherals(withServices: nil, options: nil)
    }
}


extension BLEManager: MeshServiceApiDelegate {
    func didDiscoverDevice(_ uuid: CBUUID!, rssi: NSNumber!) {
        
        let msg:[String : Any] = ["cmd": NoticeCmd.discover, "uuid": uuid, "rssi": rssi]
        broadcastMessage(msg)
    }
    
    func didAssociateDevice(_ deviceId: NSNumber!, deviceHash: Data!, meshRequestId: NSNumber!) {
        let msg:[String : Any] = ["cmd": NoticeCmd.associate, "deviceHash": deviceHash, "deviceId": deviceId, "meshRequestId": meshRequestId]
        broadcastMessage(msg)
    }
    
    func isAssociatingDevice(_ deviceHash: Data!, stepsCompleted: NSNumber!, totalSteps: NSNumber!, meshRequestId: NSNumber!) {
        let msg:[String : Any] = ["cmd": NoticeCmd.associating, "stepsCompleted": stepsCompleted, "totalSteps": totalSteps, "meshRequestId": meshRequestId]
        broadcastMessage(msg)
    }
    
    func setScannerEnabled(_ enabled: NSNumber!) {
        //print(enabled)
        if enabled == 0 {
            manager.stopScan()
        } else {
            manager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func didUpdateAppearance(_ deviceHash: Data!, appearanceValue: Data!, shortName: Data!) {
        let msg:[String : Any] = ["cmd": NoticeCmd.appearanceating, "deviceHash": deviceHash, "appearanceValue": appearanceValue, "shortName": shortName]
        broadcastMessage(msg)
    }
    
    func didTimeoutMessage(_ meshRequestId: NSNumber!) {
        let msg:[String : Any] = ["cmd": NoticeCmd.timeout, "meshRequestId": meshRequestId]
        broadcastMessage(msg)
    }
}


extension BLEManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            manager.scanForPeripherals(withServices: nil, options: nil)//[CBUUID(string: "FEF1")]
            break
        default:
            break
        }
        DeviceManager.shareManager.linking = (central.state == .poweredOn)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //print(peripheral.identifier,advertisementData,RSSI);
        //        let array = advertisementData["kCBAdvDataServiceUUIDs"] as! NSArray
        //        for a in array {
        //            print(a)//FEF1
        //        }
        var enhancedAdvertismentData = advertisementData
        enhancedAdvertismentData[CSR_PERIPHERAL] = peripheral
        let r = meshServiceApi.processMeshAdvert(enhancedAdvertismentData, rssi: RSSI) as! Int
        //print("processMeshAdvert",r)
        
        peripheral.delegate = self
        
        if r == 1 && cperipheral == nil {
            cperipheral = peripheral
            central.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnConnectionKey: true])
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        //print("didConnect",peripheral)
        peripheral.discoverServices(nil)//[CBUUID(string: "FEF1")]
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        meshServiceApi.disconnectBridge(peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        //print("didDiscoverServices", services)
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil, let characteristics = service.characteristics else {
            return
        }
        
        //print("didDiscoverCharacteristicsFor")
        
        meshServiceApi.connectBridge(peripheral, enableBridgeNotification: 1)
        for characteristic in characteristics {
            //print(characteristic.uuid.uuidString)
            if characteristic.uuid.uuidString == meshMTLCharacterUUID {
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.discoverDescriptors(for: characteristic)
                //print("meshMTLCharacterUUID",meshMTLCharacterUUID)
            }
        }
        
        //objc_setAssociatedObject(peripheral, "isBridgeService", true, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        //print(characteristic,characteristic.descriptors,error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //print("didUpdateValueFor",error,characteristic.uuid)
        
        var advertisementData = [String: Any]()
        advertisementData[CBAdvertisementDataIsConnectable] = false
        advertisementData[CSR_NotifiedValueForCharacteristic] = characteristic.value
        advertisementData[CSR_didUpdateValueForCharacteristic] = characteristic
        advertisementData[CSR_PERIPHERAL] = peripheral
        let _ = meshServiceApi.processMeshAdvert(advertisementData, rssi: nil)
        //print("processMeshAdvert",r)
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        //print("didUpdateNotificationStateFor",error,characteristic.uuid)
    }
}

extension BLEManager: PowerModelApiDelegate {
    func didGetPowerState(_ deviceId: NSNumber!, state: NSNumber!, meshRequestId: NSNumber!) {
        let msg:[String : Any] = ["cmd": NoticeCmd.powerState, "deviceId": deviceId, "state": state, "meshRequestId": meshRequestId]
        broadcastMessage(msg)
    }
}

extension BLEManager: LightModelApiDelegate {
    func didGetLightState(_ deviceId: NSNumber!, red: NSNumber!, green: NSNumber!, blue: NSNumber!, level: NSNumber!, powerState: NSNumber!, colorTemperature: NSNumber!, supports: NSNumber!, meshRequestId: NSNumber!) {
        let msg:[String : Any] = ["cmd": NoticeCmd.lightState, "deviceId": deviceId, "state": powerState, "meshRequestId": meshRequestId, "red": red, "green": green, "blue": blue, "level": level, "colorTemperature": colorTemperature, "supports": supports]
        broadcastMessage(msg)
    }
}

extension BLEManager: ConfigModelApiDelegate {
    func didResetDevice(_ deviceId: NSNumber!, deviceHash: Data!) {
        let msg:[String : Any] = ["cmd": NoticeCmd.reset, "deviceId": deviceId, "deviceHash": deviceHash]
        broadcastMessage(msg)
    }
}
