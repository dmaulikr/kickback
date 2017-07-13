//
//  Track.swift
//  Kickback
//
//  Created by Katie Jiang on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import Foundation

class Track {
    
    // Properties
    var id: String
    var name: String
    var album: [String: Any]
    var artists: [[String: Any]]
    var queuedBy: User?
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as! String
        self.name = dictionary["name"] as! String
        self.album = dictionary["album"] as! [String: Any]
        self.artists = dictionary["artists"] as! [[String: Any]]
        self.queuedBy = dictionary["queuedBy"] as? User
    }
}
