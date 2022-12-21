//
//  CentralBTProtocol.swift
//  Phone Jail
//
//  Created by David Villegas on 12/8/22.
//

import Foundation
import CoreBluetooth

protocol CentralBTDelegate: class {
    func didUpdateNearbyUsers(_ nearbyPeripherals: [Peripheral])
    func didConnect(to peripheral: CBPeripheral, nearbyPeripherals: [Peripheral])
    func didDisconnect(to peripheral: CBPeripheral, nearbyPeripherals: [Peripheral])
    func phoneJailStatusDidUpdate(_ peripheral: CBPeripheral, phoneJailStatus: PhoneJailStatus)
}

