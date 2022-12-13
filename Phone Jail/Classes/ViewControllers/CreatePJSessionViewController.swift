//
//  CreatePJSessionViewController.swift
//  Phone Jail
//
//  Created by David Villegas on 12/8/22.
//

import UIKit

class CreatePJSessionViewController: UIViewController {

    var timeDurationPicker = UIPickerView()
    
    let defaultDuration: TimeInterval = 30 * 60
    var selectedDuration: TimeInterval = 30 * 60
    
    var nonSelectedDurationButtonOrigin: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.formView()
        
    }
    
    func formView() {
        
        self.view.backgroundColor = UIColorFromRGB(0xf78e20)
        
        let jailmatesButton = UIButton()
        jailmatesButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        jailmatesButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        jailmatesButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        jailmatesButton.layer.cornerRadius = 4
        jailmatesButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        jailmatesButton.center.x = UIScreen.main.bounds.width / 2
        let titleString = NSMutableAttributedString(string: "+  jail mates")
        titleString.addAttribute(.foregroundColor, value: UIColor.systemGreen, range: NSRange(location: 0, length: 1))
        titleString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 2, length: titleString.length - 2))
        jailmatesButton.setAttributedTitle(titleString, for: .normal)
        jailmatesButton.frame.origin.y = UIScreen.main.bounds.height * 0.35
        jailmatesButton.addTarget(self, action: #selector(addJailMates), for: .touchUpInside)
        if let titleLabelSize = jailmatesButton.titleLabel?.intrinsicContentSize {
            jailmatesButton.frame = CGRect(x: 0, y: jailmatesButton.frame.origin.y, width: titleLabelSize.width + 30, height: jailmatesButton.frame.height)
            jailmatesButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: jailmatesButton.center.y)
        }
        self.view.addSubview(jailmatesButton)

        let startButton = UIButton(type: .system)
        startButton.frame = CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 50)


        // Set the background color of the button to a dark color
        startButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)

        // Set the title of the button
        startButton.setTitle("Start", for: .normal)

        // Set the title color of the button to a light color
        startButton.setTitleColor(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0), for: .normal)

        // Set the font of the button's title to a bold, sans-serif font
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)

        // Remove the drop shadow from the button
        startButton.layer.shadowColor = nil
        startButton.layer.shadowOffset = CGSize.zero
        startButton.layer.shadowRadius = 0
        startButton.layer.shadowOpacity = 0

        // Add a rounded corner to the button
        startButton.layer.cornerRadius = 8

        // Add a tap gesture recognizer to the button
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)

        // Add the button to the view
        view.addSubview(startButton)


        
        self.timeDurationPicker = UIPickerView()
        timeDurationPicker.dataSource = self
        timeDurationPicker.delegate = self
        self.view.addSubview(timeDurationPicker)
        timeDurationPicker.translatesAutoresizingMaskIntoConstraints = false
        timeDurationPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        timeDurationPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        timeDurationPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        timeDurationPicker.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.4).isActive = true
        timeDurationPicker.isHidden = true
        
        let durationButton = UIButton()
        durationButton.setTitleColor(.black, for: .normal)
        durationButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        durationButton.contentHorizontalAlignment = .center
        durationButton.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        durationButton.layer.cornerRadius = 8
        durationButton.layer.masksToBounds = true
        durationButton.insetsLayoutMarginsFromSafeArea = false
        durationButton.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        durationButton.bounds.size = CGSize(width: view.bounds.width * 0.75, height: 60)
        durationButton.frame.origin.x = self.view.frame.width * 0.125
        durationButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.height * 0.75)
        durationButton.setTitle(self.selectedDurationString, for: .normal)
        durationButton.isSelected = false
        self.nonSelectedDurationButtonOrigin = durationButton.frame.origin
        durationButton.addTarget(self, action: #selector(editDuration(_ :)), for: .touchUpInside)

        self.view.addSubview(durationButton)
    }
    
    @objc func editDuration(_ durationButton: UIButton) {
        
        durationButton.isSelected = !durationButton.isSelected
        
        var waitingForClosingAnimation: Bool = false
        
        if !durationButton.isSelected {
            self.timeDurationPicker.selectRow(0, inComponent: 0, animated: true)
            self.timeDurationPicker.selectRow(0, inComponent: 1, animated: true)
            waitingForClosingAnimation = true
            let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                self.timeDurationPicker.isHidden = !durationButton.isSelected
                durationButton.frame.origin = self.nonSelectedDurationButtonOrigin
            }
        } else {
            self.timeDurationPicker.isHidden = !durationButton.isSelected
        }
        
        if durationButton.isSelected {
            let pickerFrame = timeDurationPicker.frame
            let buttonFrame = durationButton.frame
            durationButton.frame = CGRect(x: buttonFrame.origin.x, y: pickerFrame.minY - buttonFrame.height, width: buttonFrame.width, height: buttonFrame.height)
        }
        
        if self.timeDurationPicker.isHidden == false && waitingForClosingAnimation == false {
            self.timeDurationPicker.selectRow(self.selectedDurationHours, inComponent: 0, animated: true)
            self.timeDurationPicker.selectRow(self.selectedDurationMinutes, inComponent: 1, animated: true)
        }
    }
    
    @objc func addJailMates() {
        // code to be executed when jailmatesButton is tapped
        let addJailMatesVC = AddJailMatesViewController()
        self.present(addJailMatesVC, animated: true)
    }
    
    @objc func startButtonTapped() {
        // Create an instance of JailViewController
        let targetDate = Date(timeIntervalSinceNow: 30) // one week from now
        let jailViewController = JailViewController(remainingTime: 90)
        jailViewController.modalPresentationStyle = .fullScreen
        present(jailViewController, animated: true, completion: nil)
    }

}

extension CreatePJSessionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 24
        } else if component == 1 {
            return 60
        } else {
            return 60
        }
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row) hours"
        } else if component == 1 {
            return "\(row) minutes"
        } else {
            return "\(row) seconds"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Update the selected time duration
    }
}

extension CreatePJSessionViewController {
    
    var selectedDurationHours: Int {
        let timeInterval: TimeInterval = self.selectedDuration
        let calendar = Calendar.current
        return calendar.dateComponents([.hour], from: Date(), to: Date(timeIntervalSinceNow: timeInterval)).hour ?? 0
    }
    
    var selectedDurationMinutes: Int {
        let timeInterval: TimeInterval = self.selectedDuration
        let calendar = Calendar.current
        return calendar.dateComponents([.minute], from: Date(), to: Date(timeIntervalSinceNow: timeInterval)).minute ?? 0
    }
    
    var selectedDurationString: String {
        let hour = self.selectedDurationHours
        let minute = self.selectedDurationMinutes
        var timeString = hour == 1 && minute == 1 ? "\(hour) hour, \(minute) minute" : hour == 1 ? "\(hour) hour, \(minute) minutes" : minute == 1 ? "\(hour) hours, \(minute) minute" : "\(hour) hours, \(minute) minutes"
        
        if hour == 0 {
            timeString = timeString.replacingOccurrences(of: "0 hours, ", with: "")
        }
        
        return timeString
    }
}

