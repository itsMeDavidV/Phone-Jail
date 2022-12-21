//
//  JoinSessionViewController.swift
//  Phone Jail
//
//  Created by David Villegas on 12/9/22.
//

import UIKit
import CoreBluetooth

class JoinSessionViewController: UIViewController {
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the peripheral manager
        PeripheralManagerObj = PeripheralManager()
        PeripheralManagerObj?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start advertising the user's data
        PeripheralManagerObj?.startAdvertising()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("viewDidDisappear")
        
        // Stop advertising the user's data
        PeripheralManagerObj?.stopAdvertising()
    }
}

extension JoinSessionViewController: PeripheralBTDelegate {
    func centralDidUpdate(prison: Prison) {
        print("centralDidUpdate")
            if prison.status == .inJail {
                // Present the JailViewController in full screen format
                let jailViewController = JailViewController(prison: prison)
                jailViewController.modalPresentationStyle = .fullScreen
                present(jailViewController, animated: true, completion: nil)
            }
        //PeripheralManagerObj?.sendData(data: prison.toData()!)
        }
}
