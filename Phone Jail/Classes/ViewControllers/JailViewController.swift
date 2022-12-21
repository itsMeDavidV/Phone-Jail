import UIKit
import Foundation
import CoreBluetooth

class JailViewController: UIViewController {
    
    let countdownLabel = UILabel()
    var countdownTimer: Timer?
    
    var prison: Prison
    
    var remainingTime: String {
        // Calculate the difference between the current date and the prison's release date in seconds
        let diff = Calendar.current.dateComponents([.second], from: Date(), to: prison.releaseDate).second ?? 0
        // Calculate the number of days, hours, and minutes from the number of seconds
        let days = diff / 86400
        let hours = (diff % 86400) / 3600
        let minutes = (diff % 3600) / 60
        let seconds = diff % 60
        // Build the countdown string with only non-zero values
        var countdownString = ""
        switch (days, hours, minutes, seconds) {
        case (0, 0, 0, 0):
            break
        case (0, 0, 0, let sec):
            countdownString = "\(sec) sec"
        case (0, 0, let min, let sec):
            countdownString = "\(min) min, \(sec) sec"
        case (0, let hrs, let min, let sec):
            countdownString = "\(hrs) hrs, \(min) min, \(sec) sec"
        case (let days, let hrs, let min, let sec):
            countdownString = "\(days) days, \(hrs) hrs, \(min) min, \(sec) sec"
        }
        return countdownString
    }
    
    
    init(prison: Prison) {
        self.prison = prison
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CentralDelegateObj?.delegate = self
        PeripheralManagerObj?.delegate = self
        
        // Get the AppDelegate instance
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Set the inJail property to true
        //appDelegate.inJail = true
        appDelegate.prisonObj = self.prison
        
        view.backgroundColor = UIColor.black
        
        countdownLabel.text = "\(self.remainingTime)"
        countdownLabel.textAlignment = .center
        countdownLabel.font = UIFont.systemFont(ofSize: 48)
        countdownLabel.textColor = UIColor.darkGray
        view.addSubview(countdownLabel)
        
        // Set the countdownLabel's frame to be centered in the view
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        startCountdown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Disable the idle timer to keep the screen on
        UIApplication.shared.isIdleTimerDisabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Enable the idle timer to allow the screen to go to sleep
        UIApplication.shared.isIdleTimerDisabled = false
    }

    
    
    func startCountdown() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.countdownLabel.text = self.remainingTime
            
            if self.remainingTime == "" {
                self.countdownTimer?.invalidate()
            }
        }
    }
    
    func handlePhoneJailStatus(_ phoneJailStatus: PhoneJailStatus) {
        switch phoneJailStatus {
        case .queueing:
            // Handle the "Waiting in queue" case
            break
        case .inJail:
            // Handle the "Locked up" case
            break
        case .jailBreak:
            // Handle the "Escaped from jail" case
            MakePhoneAnnoying(view: self.view)

            // Change the status of the prison object to jailBreak
            prison.status = .jailBreak

            // Send the prison object to all ready peripherals using centralDelegateObj
            CentralDelegateObj?.sendToAllReadyPeripherals(prison: prison)
            
            break
        case .allPrisonersFreed:
            // Handle the "All prisoners freed" case
            break
        }
    }

}

extension JailViewController: CentralBTDelegate {
    
    // MARK: - CentralBTDelegate methods

      func didUpdateNearbyUsers(_ nearbyPeripherals: [Peripheral]) {
        // Update the UI to reflect the new list of nearby peripherals
      }

      func didConnect(to peripheral: CBPeripheral, nearbyPeripherals: [Peripheral]) {
        // Update the UI to reflect the connection to the peripheral
      }

      func didDisconnect(to peripheral: CBPeripheral, nearbyPeripherals: [Peripheral]) {
        // Update the UI to reflect the disconnection from the peripheral
          
          if self.prison.status == .inJail {
              print("JAIL BREAK 69")
          }
      }
    
    func phoneJailStatusDidUpdate(_ peripheral: CBPeripheral, phoneJailStatus: PhoneJailStatus) {
        // Call the handlePhoneJailStatus(_:) method to handle the new phone jail status
        handlePhoneJailStatus(phoneJailStatus)
      }
    
}

extension JailViewController: PeripheralBTDelegate {
    
    // MARK: - PeripheralBTDelegate methods
    
  func centralDidUpdate(prison: Prison) {
    // Update the prison object with the new values from the central device
    self.prison = prison
    // Call the handlePhoneJailStatus(_:) method to handle the new phone jail status
    handlePhoneJailStatus(prison.status)
  }
}


