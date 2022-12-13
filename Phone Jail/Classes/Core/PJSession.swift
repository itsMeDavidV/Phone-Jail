//
//  PJSession.swift
//  Phone Jail
//
//  Created by ChatGPT on 12/8/22.
//

import Foundation

class PJSession: Encodable, Decodable {
    var participants: [PJUser]  // array of participants in the session
    var startTime: Date         // start time of the session
    var endTime: Date           // end time of the session
    var alerted: Bool           // indicates if alert has been sent
    
    // Initialize a new session with the specified participants, start time, and end time
    init(participants: [PJUser], startTime: Date, endTime: Date) {
        self.participants = participants
        self.startTime = startTime
        self.endTime = endTime
        self.alerted = false
    }
    
    // Initialize a new session from a decoder
    required init(from decoder: Decoder) throws {
        // Get the container for the session
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Define the CodingKeys enum
        enum CodingKeys: String, CodingKey {
            case participants
            case startTime
            case endTime
            case alerted
        }
        
        // Get the participants from the container
        participants = try container.decode([PJUser].self, forKey: .participants)
        
        // Get the start time from the container
        let startTimeString = try container.decode(String.self, forKey: .startTime)
        let formatter = ISO8601DateFormatter()
        startTime = formatter.date(from: startTimeString)!
        
        // Get the end time from the container
        let endTimeString = try container.decode(String.self, forKey: .endTime)
        endTime = formatter.date(from: endTimeString)!
        
        // Get the alerted flag from the container
        alerted = try container.decode(Bool.self, forKey: .alerted)
    }
    
    // Return the duration of the session as the time interval difference between the end time and the start time
    var duration: TimeInterval {
        return endTime.timeIntervalSince(startTime)
    }
    
    // Check if the session is currently in progress
    func isInProgress() -> Bool {
        return Date() < endTime
    }
    
    // Send an alert to other participants if the session has not already been alerted
    func alert() {
        if !alerted {
            // send alert to other participants here
            alerted = true
        }
    }
    
    // Encode the session and store the encoded data in the encoder
    func encode(to encoder: Encoder) throws {
        // Define the CodingKeys enum
        enum CodingKeys: String, CodingKey {
            case participants
            case startTime
            case endTime
            case alerted
        }
        
        // Get the container for the session
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode the participants
        try container.encode(participants, forKey: .participants)
        
        // Encode the start time as a string using the ISO8601DateFormatter
        let formatter = ISO8601DateFormatter()
        let startTimeString = formatter.string(from: startTime)
        try container.encode(startTimeString, forKey: .startTime)
        
        // Encode the end time as a string using the ISO8601DateFormatter
        let endTimeString = formatter.string(from: endTime)
        try container.encode(endTimeString, forKey: .endTime)
        
        // Encode the alerted flag
        try container.encode(alerted, forKey: .alerted)
    }

}
