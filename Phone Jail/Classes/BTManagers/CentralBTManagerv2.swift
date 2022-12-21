//
//  CentralBTManagerv2.swift
//  Phone Jail
//
//  Created by David Villegas on 12/15/22.
//

import Foundation
import CoreBluetooth

var CentralDelegateObj: CentralDelegate?

class CentralDelegate: NSObject, CBCentralManagerDelegate {
  // Create a delegate property of type CentralBTDelegate
  weak var delegate: CentralBTDelegate?

  // Create an array of Peripheral structs
  var peripherals: [Peripheral] = []
    
    var readyPeripherals: [Peripheral] {
        return peripherals.filter { $0.isReady }
      }

  // Create a service UUID to scan for
  let serviceUUID: CBUUID = CBUUID(string: "c5b5cf9b-9983-4adb-9457-d0c8ab3e3c3d")
    
    let readCharacteristicUUID: CBUUID = CBUUID(string: "c5b5cf9b-9983-4adb-9457-d0c8ab3e3c3c")
    let writeCharacteristicUUID: CBUUID = CBUUID(string: "c5b5cf9b-9983-4adb-9457-d0c8ab3e3c3b")

  // Create a central manager
  let centralManager = CBCentralManager()

  override init() {
    super.init()

    // Set the central manager's delegate to self
    centralManager.delegate = self
  }

  // MARK: - CBCentralManagerDelegate methods

  func centralManagerDidUpdateState(_ central: CBCentralManager) {
      print("centralManagerDidUpdateState")
      
    // Check if the central is powered on
    if central.state == .poweredOn {
      // Start scanning for peripherals with services that match the service UUID
      centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
  }

  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
      print("centralManager didDiscover peripheral \(peripheral.name)")
      
    // Check if the discovered peripheral is not in the peripherals array
    if !peripherals.contains(where: { $0.peripheral == peripheral }) {
        
        peripheral.delegate = self
        
      // Create a new Peripheral struct for the discovered peripheral
      let newPeripheral = Peripheral(peripheral: peripheral)

      // Add the new Peripheral struct to the peripherals array
      peripherals.append(newPeripheral)

      // Notify the delegate that the list of nearby peripherals has been updated
      delegate?.didUpdateNearbyUsers(peripherals)
    }
  }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("centralManager didConnect peripheral \(peripheral.name)")
        
      // Find the Peripheral object in the peripherals array that has the same CBPeripheral instance as the connected CBPeripheral
      if let index = peripherals.firstIndex(where: { $0.peripheral == peripheral }) {
        // Update the Peripheral object's peripheral property with the connected CBPeripheral
        peripherals[index].peripheral = peripheral

        // Discover the services offered by the connected CBPeripheral
        peripherals[index].peripheral.discoverServices([serviceUUID])
      }

      // Notify the delegate that a connection was made to the peripheral
      delegate?.didConnect(to: peripheral, nearbyPeripherals: peripherals)
    }

    
    func centralManager(_ central: CBCentralManager, didDisconnect peripheral: CBPeripheral) {
        print("centralManager didDisconnect peripheral \(peripheral.name)")
        
      // Find the Peripheral object in the peripherals array that has the same CBPeripheral instance as the connected CBPeripheral
      if let index = peripherals.firstIndex(where: { $0.peripheral == peripheral }) {
        // Update the Peripheral object's peripheral property with the connected CBPeripheral
        peripherals[index].peripheral = peripheral
      }

      // Notify the delegate that a connection was made to the peripheral
      delegate?.didDisconnect(to: peripheral, nearbyPeripherals: peripherals)
    }

}

extension CentralDelegate: CBPeripheralDelegate {
    
    // MARK: - CBPeripheralDelegate methods
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
      // Find the Peripheral object in the peripherals array that has the same CBPeripheral instance as the peripheral that discovered the services
      if let index = peripherals.firstIndex(where: { $0.peripheral == peripheral }) {
        // Check if the discovered services array is not empty
        if let services = peripheral.services, !services.isEmpty {
          // Update the Peripheral object's mainService property with the first service in the discovered services array
          if services.first?.uuid == serviceUUID {
            peripherals[index].mainService = services.first

            // Look for read and write characteristics for the peripheral that match the readCharacteristicUUID and writeCharacteristicUUID UUIDs, respectively
            peripheral.discoverCharacteristics([readCharacteristicUUID, writeCharacteristicUUID], for: peripherals[index].mainService!)
          }
        }

        // Notify the delegate that the list of nearby peripherals has been updated
        delegate?.didUpdateNearbyUsers(peripherals)
      }
    }

    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("peripheral didDiscoverCharacteristicsFor \(peripheral.name)")
        
      // Find the Peripheral object in the peripherals array that has the same CBPeripheral instance as the peripheral that discovered the characteristics
      if let index = peripherals.firstIndex(where: { $0.peripheral == peripheral }) {
        // Check if the discovered characteristics array is not empty
        if let characteristics = service.characteristics, !characteristics.isEmpty {
          // Iterate over the discovered characteristics
          for characteristic in characteristics {
            // Check if the characteristic has the read property
              if characteristic.uuid == self.readCharacteristicUUID {
              // Update the Peripheral object's readCharacteristic property with the characteristic
              peripherals[index].readCharacteristic = characteristic

              // Set the read characteristic's notify value to true
              peripheral.setNotifyValue(true, for: characteristic)
                
                print("requested to read")
                //peripheral.readValue(for: characteristic)
            }

            // Check if the characteristic has the write property
              if characteristic.uuid == self.writeCharacteristicUUID {
              // Update the Peripheral object's writeCharacteristic property with the characteristic
              peripherals[index].writeCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                
                //peripheral.readValue(for: characteristic)
            }
          }
        }

        // Notify the delegate that the list of nearby peripherals has been updated
        delegate?.didUpdateNearbyUsers(peripherals)
          
      }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
      // Check if there was an error updating the value of the characteristic
      if let error = error {
        // Handle the error
        print("Error updating value for characteristic: \(error)")
        return
      }

      // Check if the updated characteristic is the read characteristic of a Peripheral object
      if peripherals.contains(where: { $0.readCharacteristic == characteristic }) {
        // Get the updated value of the characteristic as a Data object
        guard let data = characteristic.value else { return }

        do {
          let jailStatus = try JSONDecoder().decode(PhoneJailStatus.self, from: data)
          // jailStatus is now a PhoneJailStatus object
          print("returned jailStatus obj = \(jailStatus)")
          // Call the delegate's phoneJailStatusDidChange method to handle the new phone jail status
          delegate?.phoneJailStatusDidUpdate(peripheral, phoneJailStatus: jailStatus)
        } catch {
          // handle the error
        }
      }
    }

    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("peripheral didWriteValueFor characteristic \(characteristic)")
        if let error = error {
          // handle error
          return
        }

        // value was successfully written to the characteristic
        
        guard let data = characteristic.value else { return }
        print("data69 = \(data)")
        print("returned prison obj = \(Prison(data: data))")
      }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("peripheral \(peripheral) didModifyServices invalidatedServices \(invalidatedServices)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateNotificationStateFor characteristic \(characteristic)")
        
        if characteristic.uuid == self.readCharacteristicUUID {
            //peripheral.readValue(for: characteristic)
            
            peripheral.readValue(for: characteristic)
        }
    }
}

extension CentralDelegate {
    
    func writeValue(data: Data, characteristic: CBCharacteristic) {
        print("writeValue data \(data) characteristic \(characteristic)")
        
        guard let service = characteristic.service else { return }
        guard let peripheral = service.peripheral else { return }

        // Check if the peripheral is connected
        if peripheral.state == .connected {
            // Write the data to the characteristic
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
        }
    }

    func sendToAllReadyPeripherals(prison: Prison) {
        guard let data = prison.toData() else { return }
        self.sendToAllReadyPeripherals(data: data)
    }

    func sendToAllReadyPeripherals(data: Data) {
        for peripheral in self.readyPeripherals {
            guard let characteristic = peripheral.writeCharacteristic else { continue }
            self.writeValue(data: data, characteristic: characteristic)
        }
    }



}

