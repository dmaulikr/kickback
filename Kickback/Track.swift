//
//  Track.swift
//  Kickback
//
//  Created by Katie Jiang on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import Foundation
import Parse

class Track: Comparable {
    
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
    var likes: Int {
        get {
            return dictionary["likes"] as! Int
        }
        set (likes) {
            dictionary["likes"] = likes
        }
    }
    var addedAt: Date {
        get {
            return dictionary["addedAt"] as! Date
        }
        set (date) {
            dictionary["addedAt"] = date
        }
    }
    
    init(_ dictionary: [String: Any]) {
        self.dictionary = dictionary
    }
    
    func like() {
        self.likes += 1
    }
    
    func dislike() {
        self.likes -= 1
    }
    
    static func < (lhs: Track, rhs: Track) -> Bool {
        if lhs.likes > rhs.likes {
            return true
        }
        if let counts = Queue.current?.counts {
            if counts[lhs.userId!]! < counts[rhs.userId!]! {
                return true
            }
        }
        return lhs.addedAt < rhs.addedAt
    }
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        return true
    }
}
