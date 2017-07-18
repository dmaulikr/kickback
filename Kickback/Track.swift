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
    var id: String
    var name: String
    var album: [String: Any]
    var artists: [[String: Any]]
    var userId: String?
    var uri: String
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as! String
        self.name = dictionary["name"] as! String
        self.album = dictionary["album"] as! [String: Any]
        self.artists = dictionary["artists"] as! [[String: Any]]
        self.userId = dictionary["userId"] as? String
        self.uri = dictionary["uri"] as! String
    }
}
