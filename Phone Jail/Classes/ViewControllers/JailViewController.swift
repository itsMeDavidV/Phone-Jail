import UIKit
import Foundation

class JailViewController: UIViewController {

    let countdownLabel = UILabel()
    var countdownTimer: Timer?
    var remainingTime: Int

    init(remainingTime: Int) {
        self.remainingTime = remainingTime
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the AppDelegate instance
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // Set the inJail property to true
        appDelegate.inJail = true

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

    func startCountdown() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.remainingTime -= 1
            self.countdownLabel.text = "\(self.remainingTime)"

            if self.remainingTime == 0 {
                self.countdownTimer?.invalidate()
            }
        }
    }
}

