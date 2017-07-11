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
    var spotify_id: String?
    var name: String?
    var queue: Queue?
    var premium: Bool?
    var parseUser: PFUser
    
    init() {
        var user = PFUser()
        user.saveInBackground()
        self.id = user.objectID
        self.parseUser = user
    }
}
