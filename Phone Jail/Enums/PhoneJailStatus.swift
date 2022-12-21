//
//  PhoneJailStatus.swift
//  Phone Jail
//
//  Created by David Villegas on 12/16/22.
//

import Foundation

enum PhoneJailStatus: String, Codable {
  case queueing = "Waiting in queue"
  case inJail = "Locked up"
  case jailBreak = "Escaped from jail"
  case allPrisonersFreed = "All prisoners freed"
}
