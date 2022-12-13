//
//  CentralBTProtocol.swift
//  Phone Jail
//
//  Created by David Villegas on 12/8/22.
//

import Foundation

protocol CentralBTDelegate: AnyObject {
    func didUpdateNearbyUsers(_ nearbyPJUsers: [String: PJUser])
}
