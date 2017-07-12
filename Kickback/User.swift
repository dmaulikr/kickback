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
    
    private static var _current: User?
    
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                var dictionary: [String: Any] = [:]
                dictionary["id"] = user.id
                dictionary["spotify_id"] = user.spotify_id
                dictionary["name"] = user.name
                dictionary["queue"] = user.queue
                dictionary["premium"] = user.premium
                dictionary["parseUser"] = user.parseUser
                let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
        
    }
    
    init(_ dictionary: [String: Any]) {
        let user = PFUser()
        user.saveInBackground()
        self.id = user.objectId!
        self.parseUser = user
        
        self.spotify_id = dictionary["spotify_id"] as! String
        self.name = dictionary["name"] as! String
        self.premium = dictionary["premium"] as! Bool
    }
}
