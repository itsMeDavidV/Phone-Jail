//
//  MainViewController.swift
//  Phone Jail
//
//  Created by David Villegas on 12/8/22.
//

import Foundation
import UIKit

class MainViewController: UIViewController {

  // MARK: - View Lifecycle

    override func viewDidLoad() {
      super.viewDidLoad()
        
        print("viewDidLoad")

        // Set the background color to a dark shade
        view.backgroundColor = UIColor.black

        // Add the background image
        let backgroundImageView = UIImageView(image: UIImage(named: "8d9accc7-40a7-4daf-adc0-513b4ee9f4ad.jpeg"))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
          backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
          backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Add the partition view
        let partitionView = UIView()
        partitionView.translatesAutoresizingMaskIntoConstraints = false
        partitionView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(partitionView)
        NSLayoutConstraint.activate([
          partitionView.topAnchor.constraint(equalTo: view.topAnchor),
          partitionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          partitionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          partitionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])


        // Add the title label
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Phone Jail"
        titleLabel.textColor = UIColor(white: 0.9, alpha: 1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
          titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.25),
          titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Add the subtitle label
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "Get back to irl"
        subtitleLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
        subtitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        view.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Add the "Join a session" button
        let joinButton = UIButton(type: .system)
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.setTitle("Join session", for: .normal)
        joinButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        joinButton.setTitleColor(.white, for: .normal)
        joinButton.backgroundColor = .clear
        joinButton.layer.borderColor = UIColor.white.cgColor
        joinButton.layer.borderWidth = 2
        joinButton.layer.cornerRadius = 25
        joinButton.addTarget(self, action: #selector(joinSessionButtonTapped), for: .touchUpInside)
        view.addSubview(joinButton)
        NSLayoutConstraint.activate([
          joinButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
          joinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
          joinButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
          joinButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Add the "Start a session" button
        let startButton = UIButton(type: .system)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle("Start session", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .clear
        startButton.layer.borderColor = UIColor.white.cgColor
        startButton.layer.borderWidth = 2
        startButton.layer.cornerRadius = 25
        startButton.addTarget(self, action: #selector(startSessionButtonTapped), for: .touchUpInside)
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
          startButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
          startButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
          startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
          startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc func joinSessionButtonTapped() {
      let joinSessionViewController = JoinSessionViewController()
      joinSessionViewController.modalPresentationStyle = .fullScreen
      present(joinSessionViewController, animated: true)
    }
    
    @objc func startSessionButtonTapped() {
      let createSessionViewController = CreateSessionViewController()
      createSessionViewController.modalPresentationStyle = .fullScreen
      present(createSessionViewController, animated: true)
    }


}

