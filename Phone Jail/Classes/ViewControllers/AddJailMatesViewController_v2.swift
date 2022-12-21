//
//  AddJailMatesViewController_v2.swift
//  Phone Jail
//
//  Created by David Villegas on 12/16/22.
// 

import UIKit
import CoreBluetooth

class AddPrisonersViewController: UIViewController {

  // Create a table view and a central delegate object
  let tableView = UITableView()
    let confirmButton = UIButton(type: .system)
    
    var prison: Prison
    
    init(prison: Prison) {
      self.prison = prison
      super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

  override func viewDidLoad() {
    super.viewDidLoad()
      print("ViewController viewDidLoad")

      // Initialize the central delegate
      CentralDelegateObj = CentralDelegate()
      
    // Set the central delegate's delegate to self
      CentralDelegateObj?.delegate = self

    // Set up the table view
    tableView.dataSource = self
    tableView.delegate = self
    //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
      tableView.backgroundColor = UIColor.white
    view.addSubview(tableView)
      
      // Add the confirm button
              confirmButton.setTitle("Confirm", for: .normal)
              confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
      confirmButton.backgroundColor = UIColor.systemBlue
              view.addSubview(confirmButton)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    // Set the table view's frame
    tableView.frame = view.bounds
      
      // Set the confirm button's frame
              let confirmButtonSize = CGSize(width: 100, height: 44)
      let confirmButtonOrigin = CGPoint.zero
      confirmButton.frame.origin.y = 150
              confirmButton.frame = CGRect(origin: confirmButtonOrigin, size: confirmButtonSize)
  }
    
    @objc func confirmButtonTapped() {
        // Store a reference to the parent view controller
        let parent = self.parent as? CreateSessionViewController

        // Remove the view controller from its parent
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()

        // Dismiss the view
        dismiss(animated: true) {
            // Attribute the prison and centralDelegate properties to the parent
            parent?.prison = self.prison
            // Set the centralDelegate's delegate to the parent
            CentralDelegateObj?.delegate = parent
        }
    }





}

// MARK: - CentralBTDelegate methods

extension AddPrisonersViewController: CentralBTDelegate {
    
    func phoneJailStatusDidUpdate(_ peripheral: CBPeripheral, phoneJailStatus: PhoneJailStatus) {
        print("phoneJailStatusDidUpdate")
    }

    func didUpdateNearbyUsers(_ nearbyPeripherals: [Peripheral]) {
      // Filter the nearby peripherals to only include those with a read and write characteristic and that are connected
      let connectedPeripherals = nearbyPeripherals.filter { $0.readCharacteristic != nil && $0.writeCharacteristic != nil && $0.peripheral.state == .connected }

      // Create a new array of prisoner names by mapping the connected peripherals to their names
      let prisonerNames = connectedPeripherals.map { $0.peripheral.name ?? "Unnamed Prisoner" }

      // Update the prison's prisonerNames property with the new array of prisoner names
      prison.prisonerNames = prisonerNames

      // Reload the table view's data
      tableView.reloadData()
        
        CentralDelegateObj?.sendToAllReadyPeripherals(prison: self.prison)
    }

  func didConnect(to peripheral: CBPeripheral, nearbyPeripherals: [Peripheral]) {
    // Reload the table view's data
    tableView.reloadData()
      
      CentralDelegateObj?.sendToAllReadyPeripherals(prison: self.prison)
  }

  func didDisconnect(to peripheral: CBPeripheral, nearbyPeripherals: [Peripheral]) {
    // Reload the table view's data
    tableView.reloadData()
      
      CentralDelegateObj?.sendToAllReadyPeripherals(prison: self.prison)
  }

}

// MARK: - UITableViewDataSource methods

extension AddPrisonersViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of peripherals in the central delegate's peripherals array
      return CentralDelegateObj?.peripherals.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()

    // Get the Peripheral object for the current row
    let peripheral = CentralDelegateObj?.peripherals[indexPath.row]

    // Set the cell's text label to the peripheral's name
      cell.textLabel?.text = peripheral?.peripheral.name

    // Check if the peripheral is connected
      if peripheral?.peripheral.state == .connected {
      // Set the cell's background color to green
      cell.backgroundColor = .green
    } else {
      // Set the cell's background color to white
      cell.backgroundColor = .white
    }

    return cell
  }

}

// MARK: - UITableViewDelegate methods

extension AddPrisonersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the Peripheral object for the selected row
        guard let peripheral = CentralDelegateObj?.peripherals[indexPath.row] else { return }
        
        // Check if the peripheral is not already
        // Connect to the peripheral
        CentralDelegateObj?.centralManager.connect(peripheral.peripheral, options: nil)
    }
}



