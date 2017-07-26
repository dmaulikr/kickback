//
//  UserCell.swift
//  Kickback
//
//  Created by Katie Jiang on 7/25/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class UserCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    var userId: String? {
        didSet {
            // Make profile picture circlar
            profileImage.layer.cornerRadius = profileImage.frame.height / 2
            profileImage.layer.masksToBounds = false
            profileImage.clipsToBounds = true
            if let userId = userId {
                do {
                    let parseUser = try PFQuery(className: "SPTUser").whereKey("id", equalTo: userId).getFirstObject()
                    if let url = parseUser["profileImageURL"] {
                        profileImage.af_setImage(withURL: URL(string: url as! String)!)
                    }
                    usernameLabel.text = parseUser["name"] as? String
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
