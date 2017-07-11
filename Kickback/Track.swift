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
    var albumID: String
    var artistID: String
    var queuedBy: User?
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as! String
        self.name = dictionary["name"] as! String
        self.albumID = dictionary["albumID"] as! String
        self.artistID = dictionary["artistID"] as! String
        self.queuedBy = dictionary["queuedBy"] as? User
    }
}
