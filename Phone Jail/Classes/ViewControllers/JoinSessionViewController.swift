//
//  JoinSessionViewController.swift
//  Phone Jail
//
//  Created by David Villegas on 12/9/22.
//

import UIKit
import CoreBluetooth

class JoinSessionViewController: UIViewController {
    // MARK: Properties
    
    var user: PJUser
    var peripheralManager: PeripheralManager!
    
    // MARK: Initialization
    
    init(user: PJUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the peripheral manager
        peripheralManager = PeripheralManager(user: user)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start advertising the user's data
        peripheralManager.startAdvertising()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Stop advertising the user's data
        peripheralManager.stopAdvertising()
    }
}
