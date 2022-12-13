//
//  AddJailMatesViewController.swift
//  Phone Jail
//
//  Created by David Villegas on 12/8/22.
//

import UIKit

class AddJailMatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    //let possibleJailMates: [PJUser] = [PJUser(firstName: "Jon", lastName: "Doe"),PJUser(firstName: "Jane", lastName: "Doe")]
    
    var central: CentralBTManager?
    
    var nearbyPJUsers: [String:PJUser] = [:]
    
    var pjUserPeripheralNames: [String] {
        guard self.nearbyPJUsers.isEmpty == false else { return [] }
        return self.nearbyPJUsers.keys.map { String($0) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("AddJailMatesViewController")
        
        let central = CentralBTManager()
        central.delegate = self
        self.central = central

        self.formView()
    }
    
    func formView() {
        
        self.view.backgroundColor = UIColor.white
        
        tableView.frame = view.bounds
        tableView.backgroundColor = UIColor.white
        //tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        view.addSubview(tableView)

    }
}

extension AddJailMatesViewController {
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection
        if indexPath.row < self.pjUserPeripheralNames.count {
            let selectedJailMate = self.pjUserPeripheralNames[indexPath.row]
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the table view
        return self.pjUserPeripheralNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Get the name of the user at the current index
        let pjUserPeripheralName = self.pjUserPeripheralNames[indexPath.row]

        // Get the user object for the user with the current name
        let user = self.nearbyPJUsers[pjUserPeripheralName] ?? PJUser(firstName: "", lastName: "")

        // Create a new PJUserTableViewCell with the user object
        let userTableViewCell = PJUserTableViewCell(style: .default, reuseIdentifier: "cell", user: user)

        // Return the user table view cell
        return userTableViewCell
    }

    
}

extension AddJailMatesViewController: CentralBTDelegate {
    func didUpdateNearbyUsers(_ nearbyPJUsers: [String : PJUser]) {
        print("didUpdateNearbyUsers")
        self.nearbyPJUsers = nearbyPJUsers
        self.tableView.reloadData()
    }
}
