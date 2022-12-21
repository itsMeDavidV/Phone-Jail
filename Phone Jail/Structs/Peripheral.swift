//
//  Peripheral.swift
//  Phone Jail
//
//  Created by David Villegas on 12/15/22.
//

import Foundation
import CoreBluetooth

struct Peripheral {
  var peripheral: CBPeripheral
  var mainService: CBService?
  var readCharacteristic: CBCharacteristic?
  var writeCharacteristic: CBCharacteristic?

  init(peripheral: CBPeripheral) {
    self.peripheral = peripheral
  }
    
    var isReady: Bool {
        return mainService != nil && readCharacteristic != nil && writeCharacteristic != nil && peripheral.state == .connected
      }
}

