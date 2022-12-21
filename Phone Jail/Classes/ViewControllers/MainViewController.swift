//
//  MainViewController.swift
//  Phone Jail
//
//  Created by David Villegas on 12/8/22.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            // Handle the response from the user.
        }

        // Set the background color for the view
        self.view.backgroundColor = UIColorFromRGB(0x1d1d1d)

        // Set the title color for the navigation item
        //self.navigationItem.titleTextAttributes = [.foregroundColor: UIColor.white]

        // Create the buttons
        let newSessionButton = UIButton(type: .system)
        newSessionButton.setTitle("New Session", for: .normal)
        newSessionButton.backgroundColor = UIColorFromRGB(0xf78e20)
        newSessionButton.setTitleColor(UIColor.white, for: .normal)

        let joinSessionButton = UIButton(type: .system)
        joinSessionButton.setTitle("Join Session", for: .normal)
        joinSessionButton.backgroundColor = UIColorFromRGB(0xf78e20)
        joinSessionButton.setTitleColor(UIColor.white, for: .normal)

        // Add rounded corners and a shadow to the buttons
        newSessionButton.layer.cornerRadius = 8
        newSessionButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        joinSessionButton.layer.cornerRadius = 8
        joinSessionButton.layer.shadowOffset = CGSize(width: 2, height: 2)

        // Use a different font for the button titles
        let font = UIFont(name: "Lucida Console", size: 16)
        newSessionButton.titleLabel?.font = font
        joinSessionButton.titleLabel?.font = font

        // Calculate the button width
        let buttonWidth = self.view.frame.width * 0.75

        // Set the frames for the buttons
        let buttonHeight: CGFloat = 50
        let padding: CGFloat = 20
        newSessionButton.frame = CGRect(x: self.view.center.x - (buttonWidth / 2), y: self.view.center.y - (buttonHeight + padding), width: buttonWidth, height: buttonHeight)
        joinSessionButton.frame = CGRect(x: self.view.center.x - (buttonWidth / 2), y: newSessionButton.frame.origin.y + newSessionButton.frame.height + padding, width: buttonWidth, height: buttonHeight)
        
        // Add the buttons to the view
        self.view.addSubview(newSessionButton)
        self.view.addSubview(joinSessionButton)

        // Add action methods for the buttons
        newSessionButton.addTarget(self, action: #selector(startNewSession), for: .touchUpInside)
        joinSessionButton.addTarget(self, action: #selector(joinSession), for: .touchUpInside)
    }



    @objc func startNewSession() {
        // Present a new view controller for starting a new session
        let createSessionViewController = CreateSessionViewController()
        createSessionViewController.modalPresentationStyle = .fullScreen
        self.present(CreateSessionViewController(), animated: true)
    }

    @objc func joinSession() {
        // Initialize the JoinSessionViewController
        let joinSessionViewController = JoinSessionViewController()
        joinSessionViewController.modalPresentationStyle = .fullScreen
        // Present the JoinSessionViewController
        self.present(joinSessionViewController, animated: true)
    }

    
    @objc func accessSettings() {
        // Present a new view controller for accessing settings
    }
}

