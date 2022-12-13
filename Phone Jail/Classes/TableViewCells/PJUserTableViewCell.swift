//
//  PJUserTableViewCell.swift
//  Phone Jail
//
//  Created by David Villegas on 12/8/22.
//

import UIKit

class PJUserTableViewCell: UITableViewCell {

    let profilePicture = UIImageView()
    let nameLabel = UILabel()
    
    // Make the user property non-optional
    var user: PJUser

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, user: PJUser) {
        self.user = user
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(profilePicture)
        contentView.addSubview(nameLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let profilePictureSize = bounds.height * 0.65
        profilePicture.frame = CGRect(x: 30, y: (bounds.height - profilePictureSize) / 2, width: profilePictureSize, height: profilePictureSize)
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.layer.cornerRadius = profilePictureSize / 2
        profilePicture.backgroundColor = UIColor.lightGray

        let labelWidth = bounds.width - profilePicture.frame.maxX - 20
        
        // Set the nameLabel text to the user's full name
        nameLabel.text = "\(user.firstName) \(user.lastName)"

        nameLabel.frame = CGRect(x: profilePicture.frame.maxX + 10, y: 0, width: labelWidth, height: bounds.height)
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 16)
    }
}
