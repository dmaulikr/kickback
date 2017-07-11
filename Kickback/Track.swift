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
    
    init(id: String, name: String, albumID: String, artistID: String, queuedBy: User?) {
        self.id = id
        self.name = name
        self.albumID = albumID
        self.artistID = artistID
        self.queuedBy = queuedBy
    }
}
