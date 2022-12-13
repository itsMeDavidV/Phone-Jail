//
//  FirstViewController.swift
//  Phone Jail
//
//  Created by David Villegas on 12/8/22.
//

import UIKit

class FirstViewController: UIViewController {

    // MARK: - Properties

    // Navigation controller
    //var navigationController: UINavigationController?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("FirstViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Check if a user exists in the keychain
        KeychainStore.getUserFromKeychain { user, error in
            if let error = error {
                // Print the error
                print(error)
            }

            if let user = user {
                // Set the user
                SetUser(user)
                // User exists in keychain, present the main app screen
                let mainViewController = MainViewController()
                mainViewController.modalPresentationStyle = .fullScreen
                self.present(mainViewController, animated: true, completion: nil)
            } else {
                // User does not exist in keychain, push to the sign up screen
                self.present(SignUpViewController(), animated: true)
            }
        }
    }
    
    
}
