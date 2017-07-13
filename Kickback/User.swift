//
//  User.swift
//  Kickback
//
//  Created by Katie Jiang on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import Foundation
import Parse

class User {
    
    // Properties
    var id: String
    var spotify_id: String
    var name: String
    var queue: Queue?
    var premium: Bool
    var parseUser: PFUser
    
<<<<<<< HEAD
    init() {
=======
    init(_ dictionary: [String: Any]) {
>>>>>>> 159873acb4377cf97166c2a4ca7d275755cd2b59
        let user = PFUser()
        user.saveInBackground()
        self.id = user.objectId!
        self.parseUser = user
        
        self.spotify_id = dictionary["spotify_id"] as! String
        self.name = dictionary["name"] as! String
        self.premium = dictionary["premium"] as! Bool
    }
}
