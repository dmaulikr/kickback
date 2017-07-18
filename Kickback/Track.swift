//
//  Track.swift
//  Kickback
//
//  Created by Katie Jiang on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import Foundation
import Parse

class Track {
    
    // Properties
    var dictionary: [String: Any]
    
    var id: String {
        get {
            return dictionary["id"] as! String
        }
        set (id) {
            dictionary["id"] = id
        }
    }
    var name: String {
        get {
            return dictionary["name"] as! String
        }
        set (name) {
            dictionary["name"] = name
        }
    }
    var album: [String: Any] {
        get {
            return dictionary["album"] as! [String: Any]
        }
        set (album) {
            dictionary["album"] = album
        }
    }
    var artists: [[String: Any]] {
        get {
            return dictionary["artists"] as! [[String: Any]]
        }
        set (artists) {
            dictionary["artists"] = artists
        }
    }
    var userId: String? {
        get {
            return dictionary["userId"] as? String
        }
        set (userId) {
            dictionary["userId"] = userId
        }
    }
    var uri: String {
        get {
            return dictionary["uri"] as! String
        }
        set (uri) {
            dictionary["uri"] = uri
        }
    }
    
    init(_ dictionary: [String: Any]) {
        self.dictionary = dictionary
    }
}
