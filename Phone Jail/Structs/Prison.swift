//
//  Prison.swift
//  Phone Jail
//
//  Created by David Villegas on 12/16/22.
//

import Foundation

struct Prison: Codable {
  var status: PhoneJailStatus
  var releaseDate: Date
  var escapeeNames: [String]?
  var prisonerNames: [String]

  init(status: PhoneJailStatus, releaseDate: Date, escapeeNames: [String]?, prisonerNames: [String]) {
    self.status = status
    self.releaseDate = releaseDate
    self.escapeeNames = escapeeNames
    self.prisonerNames = prisonerNames
  }

  func toData() -> Data? {
    let encoder = JSONEncoder()
    return try? encoder.encode(self)
  }

  init?(data: Data) {
    let decoder = JSONDecoder()
    guard let prison = try? decoder.decode(Prison.self, from: data) else { return nil }
    self = prison
  }
}

