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
    var id: String // corresponds to the spotify ID
    var name: String
    var queueId: String?
    var premium: Bool
    var profileImageURL: String
    
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
                dictionary["name"] = user.name
                dictionary["profileImageURL"] = user.profileImageURL
                dictionary["queueId"] = user.queueId
                dictionary["premium"] = user.premium
                let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as! String
        self.name = dictionary["name"] as! String
        self.premium = dictionary["premium"] as! Bool
        self.profileImageURL = dictionary["profileImageURL"] as! String
        self.queueId = dictionary["queueId"] as? String
    }
    
    func add(queueId: String) {
        self.queueId = queueId
    }
}
