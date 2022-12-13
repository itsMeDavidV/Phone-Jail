//
//  Keychain.swift
//  Phone Jail
//
//  Created by ChatGPT on 12/8/22.
//

import Foundation
import KeychainAccess

class KeychainStore {
    
    // MARK: - Properties
    
    // Keychain access group ID
    private static let KeyChainAccessGroup = "your.keychain.access.group"
    private static let KeyChainService = "your.keychain.service"
    
    // MARK: - Initialization
    
    // Private initializer to prevent multiple instances of the Keychain class
    private init() {}
    
    // MARK: - Keychain Methods
    
    // Save the user to the keychain
    static func saveUserToKeychain(_ user: PJUser, completion: @escaping (Error?) -> Void) {
        let keychain = Keychain(service: KeyChainService, accessGroup: KeyChainAccessGroup)
        
        // Convert the PJUser object to Data
        guard let data = user.toData() else {
            completion(NSError(domain: "PhoneJailErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to encode PJUser object to Data."]))
            return
        }
        
        // Save the user's data to the keychain
        keychain[data: "user"] = data
        
        // Call the completion handler with no error
        completion(nil)
    }
    
    // Retrieve a PJUser object from the keychain
    static func getUserFromKeychain(completion: @escaping (PJUser?, Error?) -> Void) {
        let keychain = Keychain(service: KeyChainService, accessGroup: KeyChainAccessGroup)
        
        // Get the user's data from the keychain
        do {
            let data = try keychain.getData("user")
            
            guard let retrievedData = data else {
                completion(nil, nil)
                return
            }
            
            // Convert the Data object to a PJUser object
            let user = PJUser(data: retrievedData)
            completion(user, nil)
        } catch let error {
            completion(nil, error)
        }
    }
}
