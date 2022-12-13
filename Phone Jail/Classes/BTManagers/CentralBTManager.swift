//
//  CentralBTManager.swift
//  Phone Jail
//
//  Created by David Villegas on 12/8/22.
//

import Foundation
import CoreBluetooth

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

class CentralBTManager: NSObject {
    
    // MARK: - Properties
    
    var centralManager: CBCentralManager!
    var pjPeripherals: [CBPeripheral] = []
    var nearbyPJUsers: [String:PJUser] = [:]
    
    let serviceUUID: CBUUID = CBUUID(string: "c5b5cf9b-9983-4adb-9457-d0c8ab3e3c3d")
    
    var delegate: CentralBTDelegate?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Helper Methods
    
    func startScanning() {
        pjPeripherals = []
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
}

// MARK: - CBCentralManagerDelegate

extension CentralBTManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("Bluetooth status is UNKNOWN")
        case .resetting:
            print("Bluetooth status is RESETTING")
        case .unsupported:
            print("Bluetooth status is UNSUPPORTED")
        case .unauthorized:
            print("Bluetooth status is UNAUTHORIZED")
        case .poweredOff:
            print("Bluetooth status is POWERED OFF")
        case .poweredOn:
            print("Bluetooth status is POWERED ON")
            startScanning()
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("didDiscover peripheral \(peripheral)")
        
        // Create a regular expression to match the pattern
        let regex = try! NSRegularExpression(pattern: "^phoneJail69-.+$")

        // Get the name of the peripheral from the advertisement data
        let peripheralName = peripheral.name

        // Check if the peripheral name matches the regex
        if let peripheralName = peripheralName, peripheralName.matches("^phoneJail69-.+$") {
          // If the peripheral name matches the regex, add it to the array of matching peripherals
            
            print("mathch!!!")
            self.addUniquePeripheral(peripheral)
        } else {
            print("no match")
        }
    }
}


extension CentralBTManager {
    
    func addUniquePeripheral(_ peripheral: CBPeripheral) {
        print("addUniquePeripheral")
      // Check if the array of peripherals already contains a peripheral with the same name as the one being added
      if !pjPeripherals.contains(where: { $0.name == peripheral.name }) {
          // If not, add the peripheral to the array
          pjPeripherals.append(peripheral)
          
          if let userObj = self.createPJUser(peripheral: peripheral) {
              self.updateNearbyUsers(from: peripheral, with: userObj)
          }
      }
    }

    func createPJUser(peripheral: CBPeripheral) -> PJUser? {
        // Create a regex pattern to match the "phoneJail69-" prefix
        let pattern = "^phoneJail69-"
        
        // Use the regex pattern to extract the first name from the peripheral name
        let firstName = (peripheral.name ?? "").replacingOccurrences(of: pattern, with: "", options: .regularExpression)
        
        // Create a new PJUser with the extracted first name and the peripheral identifier
        let user = PJUser(firstName: firstName, lastName: "")
        user.peripheralID = peripheral.identifier.uuidString
        
        // Return the PJUser
        return user
    }

    
    func updateNearbyUsers(from peripheral: CBPeripheral, with user: PJUser) {
        guard let peripheralName = peripheral.name else { return }
        nearbyPJUsers.updateValue(user, forKey: peripheralName)
        
        if let delegate = self.delegate {
            delegate.didUpdateNearbyUsers(self.nearbyPJUsers)
        }
    }
}

