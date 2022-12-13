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

class PeripheralManager: NSObject, CBPeripheralManagerDelegate {
    // MARK: Properties
    
    var peripheralManager: CBPeripheralManager!
    var user: PJUser
    let serviceUUID: CBUUID = CBUUID(string: "c5b5cf9b-9983-4adb-9457-d0c8ab3e3c3d")
    
    // MARK: Initialization
    
    init(user: PJUser) {
        self.user = user
        super.init()
        
        // Initialize the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    // MARK: Peripheral Management
    
    func startAdvertising() {
        
        guard let user = User else { return }
        let pjData = user.toData()
        
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
        
        var deviceName = "\(user.firstName)\("'s") \(UIDevice.current.name)"
        
        if UIDevice.current.systemVersion < "16.0" {
            // This code will only be executed on earlier versions of iOS
            deviceName = UIDevice.current.name
        }
        return "phoneJail69-\(deviceName)"
    }

    // MARK: CBPeripheralManagerDelegate
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
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
}
