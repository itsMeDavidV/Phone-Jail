//
//  PeripheralBTManager.swift
//  Phone Jail
//
//  Created by David Villegas on 12/9/22.
//

//regex: ^phoneJailSesh\w{0,7}\.\d{3}[A-Z]$


import Foundation
import CoreBluetooth
import UIKit

extension String {
    static func randomCapitalizedLetter() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let randomIndex = Int.random(in: 0..<letters.count)
        let randomCharacter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
        return String(randomCharacter)
    }
}

var PeripheralManagerObj: PeripheralManager?

class PeripheralManager: NSObject, CBPeripheralManagerDelegate {
    // MARK: Properties
    
    var delegate: PeripheralBTDelegate?
    
    var peripheralManager: CBPeripheralManager!
    let serviceUUID: CBUUID = CBUUID(string: "c5b5cf9b-9983-4adb-9457-d0c8ab3e3c3d")
    
    // Create a characteristic for the service
    
    let readCharacteristicUUID: CBUUID = CBUUID(string: "c5b5cf9b-9983-4adb-9457-d0c8ab3e3c3c")
    let writeCharacteristicUUID: CBUUID = CBUUID(string: "c5b5cf9b-9983-4adb-9457-d0c8ab3e3c3b")
    
    var readCharacteristic: CBMutableCharacteristic = CBMutableCharacteristic(
        type: CBUUID(string: "c5b5cf9b-9983-4adb-9457-d0c8ab3e3c3c"),
        properties: [.notify,.read],
        value: nil,
        permissions: [.readable]
    )
    
    var writeCharacteristic: CBMutableCharacteristic = CBMutableCharacteristic(
        type: CBUUID(string: "c5b5cf9b-9983-4adb-9457-d0c8ab3e3c3b"),
        properties: [.read, .write, .notify],
        value: nil,
        permissions: [.readable, .writeable])
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        // Initialize the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    // MARK: Peripheral Management
    
    func startAdvertising() {
        
        stopAdvertising()
        
        peripheralManager.removeAllServices()
        
        // Create a service and add the characteristic to it
        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [writeCharacteristic,readCharacteristic]
        
        // Add the service to the peripheral manager
        peripheralManager.add(service)
        
        // Create a dictionary of advertisement data
        let advertisementData: [String: Any] = [
            CBAdvertisementDataLocalNameKey: generatePeripheralName(),
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID]
        ]
        
        print("advertisementData = \(advertisementData)")
        
        // Start advertising the service
        peripheralManager.startAdvertising(advertisementData)
    }
    
    func stopAdvertising() {
        // Stop advertising the service
        peripheralManager.stopAdvertising()
    }
    
    // MARK: Peripheral Name Generation
    
    func generatePeripheralName() -> String {
        return UIDevice.current.name
    }

    // MARK: CBPeripheralManagerDelegate
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        // This method is called when the peripheral manager's state is updated.
        // Use this method to determine if the peripheral manager is powered on and available to use.
        
        print("peripheralManagerDidUpdateState - \(peripheral.state)")
        // Check the state of the peripheral manager
        switch peripheral.state {
            case .poweredOn:
                // Peripheral manager is powered on, start advertising the service
                startAdvertising()
            
            default:
                // Peripheral manager is not in the correct state, stop advertising the service
            stopAdvertising()
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("peripheralManagerDidStartAdvertising peripheral = \(peripheral), error = \(error)")
        
        if error != nil {
            stopAdvertising()
            startAdvertising()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        // This method is called when the peripheral receives one or more write requests from a central.
        // Use this method to process the write requests and provide a response, if needed.
        
        print("peripheralManager didReceiveWrite requests \(requests)")

        // Iterate over the write requests
        for request in requests {
            print("request.value = \(request.value)")

            // Check if the request's characteristic value is equal to the write characteristic
            if request.characteristic.uuid == writeCharacteristic.uuid {
                // Try to convert the request's value to a Prison object
                
                if let data = request.value, let prison = Prison(data: data) {
                    if let delegate = self.delegate {
                        delegate.centralDidUpdate(prison: prison)
                    }
                }
                
                self.peripheralManager.respond(to: request, withResult: .success)
            }
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        // This method is called when a central device subscribes to a characteristic of the peripheral.
        // Use this method to start sending updates for the characteristic, if needed.
        
        if characteristic.uuid == self.readCharacteristicUUID {
            guard let data = try? JSONEncoder().encode(PhoneJailStatus.inJail) else { return }

            // Call the sendData method and pass the encoded data
            PeripheralManagerObj?.sendData(data: data, centrals: nil)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        // This method is called when the peripheral receives a read request from a central.
        // Use this method to process the read request and provide a response, if needed.
        
        print("peripheralManager \(peripheral) didReceiveRead \(request)")
        
        
        self.peripheralManager.respond(to: request, withResult: .success)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        // This method is called when the peripheral manager is about to be restored by the system.
        // Use this method to retrieve any data that needs to be restored, such as services and characteristics.
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        // This method is called when a service has been successfully added to the peripheral manager.
        // Use this method to add characteristics to the service, if needed.
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        // This method is called when a central device unsubscribes from a characteristic of the peripheral.
        // Use this method to stop sending updates for the characteristic, if needed.
    }

    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        print("peripheralManagerIsReady toUpdateSubscribers")
        // This method is called when the peripheral manager is ready to send updates for a characteristic.
        // Use this method to send updates for the characteristic, if needed.
    }

}

extension PeripheralManager {
    func sendData(data: Data, centrals: [CBCentral]? = nil) {
        print("sendData \(data)")
        // Update the value of the readCharacteristic
        readCharacteristic.value = data
        // Notify all subscribers that the value of the characteristic has been updated
        print("readCharacteristic = \(readCharacteristic)")
        peripheralManager.updateValue(data, for: readCharacteristic, onSubscribedCentrals: centrals)
        print("readCharacteristic = \(readCharacteristic)")
        //self.startAdvertising()
        
    }
}


