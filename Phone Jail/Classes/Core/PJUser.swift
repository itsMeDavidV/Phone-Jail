//
//  PJUser.swift
//  Phone Jail
//
//  Created by ChatGPT on 12/8/22.
//

import Foundation

var User: PJUser?

func SetUser(_ user: PJUser) {
    User = user
}

// Define the PJUserDictionary struct
struct PJUserDictionary: Encodable, Decodable {
    let firstName: String
    let lastName: String
    let activeSession: Data?
    let previousSession: Data?
    let totalTime: TimeInterval
}

class PJUser: Encodable, Decodable {
    var firstName: String        // first name of the user
    var lastName: String         // last name of the user
    var activeSession: PJSession? // optional active session for the user
    var previousSession: PJSession? // optional previous session for the user
    var totalTime: TimeInterval  // total time the user has spent in PJ sessions
    var peripheralID: String?
    
    // Initialize a new user with the specified first and last name
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.activeSession = nil
        self.previousSession = nil
        self.totalTime = 0
    }
    
    // Initialize a new user from Data
    init(data: Data) {
        // Get the dictionary from the Data object
        guard let dictionary = try? JSONDecoder().decode(PJUserDictionary.self, from: data) else {
            fatalError("Unable to decode PJUser from Data.")
        }
        
        // Get the user's first and last name from the dictionary
        self.firstName = dictionary.firstName
        self.lastName = dictionary.lastName
        
        // Get the user's active session from the dictionary
        if let activeSessionData = dictionary.activeSession {
            self.activeSession = try? JSONDecoder().decode(PJSession.self, from: activeSessionData)
        }
        
        // Get the user's previous session from the dictionary
        if let previousSessionData = dictionary.previousSession {
            self.previousSession = try? JSONDecoder().decode(PJSession.self, from: previousSessionData)
        }
        
        // Get the user's total time from the dictionary
        self.totalTime = dictionary.totalTime
    }
    
    // Increment the total time for the user by a given amount
    func incrementTotalTime(by time: TimeInterval) {
        totalTime += time
    }
    
    // Convert the PJUser object to Data
    func toData() -> Data? {
        // Encode the active session and previous session as Data
        let activeSessionData = try? JSONEncoder().encode(activeSession)
        let previousSessionData = try? JSONEncoder().encode(previousSession)
        
        // Create a dictionary from the user's properties
        let dictionary = PJUserDictionary(
            firstName: firstName,
            lastName: lastName,
            activeSession: activeSessionData,
            previousSession: previousSessionData,
            totalTime: totalTime
        )
        
        // Encode the dictionary as Data and return it
        return try? JSONEncoder().encode(dictionary)
    }

}
