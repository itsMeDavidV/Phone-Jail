//
//  SignUpViewController.swift
//  Phone Jail
//
//  Created by David Villegas on 12/8/22.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    // Text fields for first name, last name, and email
    private let firstNameTextField = UITextField()
    private let lastNameTextField = UITextField()
    
    // Sign up button
    private let signUpButton = UIButton()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SignUpViewController")
        
        // Set up text fields
        firstNameTextField.delegate = self
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.borderStyle = .roundedRect
        firstNameTextField.autocapitalizationType = .words
        view.addSubview(firstNameTextField)
        
        lastNameTextField.delegate = self
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.borderStyle = .roundedRect
        lastNameTextField.autocapitalizationType = .words
        view.addSubview(lastNameTextField)
        
        // Set up sign up button
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        view.addSubview(signUpButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Lay out text fields
        let textFieldMargin: CGFloat = 20
        let textFieldHeight: CGFloat = 44
        let textFieldWidth = view.bounds.width - 2 * textFieldMargin
        
        firstNameTextField.frame = CGRect(x: textFieldMargin,
                                          y: 100,
                                          width: textFieldWidth,
                                          height: textFieldHeight)
        
        lastNameTextField.frame = CGRect(x: textFieldMargin,
                                         y: firstNameTextField.frame.maxY + textFieldMargin,
                                         width: textFieldWidth,
                                         height: textFieldHeight)
        
        // Lay out sign up button
        let signUpButtonMargin: CGFloat = 20
        let signUpButtonHeight: CGFloat = 44
        let signUpButtonWidth = view.bounds.width - 2 * signUpButtonMargin
        signUpButton.frame = CGRect(x: signUpButtonMargin,
                                    y: lastNameTextField.frame.maxY + signUpButtonMargin,
                                    width: signUpButtonWidth,
                                    height: signUpButtonHeight)
    }
    
    // MARK: - Actions
    
    // Sign up button action
    @objc private func signUpButtonTapped(_ sender: UIButton) {
        // Validate input
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            showErrorAlert(message: "Please enter your first name.")
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            showErrorAlert(message: "Please enter your last name.")
            return
        }
        // Create a new PJUser object with the provided first and last name
        let user = PJUser(firstName: firstName, lastName: lastName)

        // Save the user to the keychain
        KeychainStore.saveUserToKeychain(user) { error in
            if let error = error {
                // Show error alert
                self.showErrorAlert(message: error.localizedDescription)
                return
            }

            // Transition to the main app screen
            if let navigationController = self.navigationController {
                // Pop to root view controller and present MainViewController
                navigationController.popToRootViewController(animated: false)
                navigationController.present(MainViewController(), animated: true)
            } else {
                // Present MainViewController from self
                self.present(MainViewController(), animated: true)
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}


                                      
