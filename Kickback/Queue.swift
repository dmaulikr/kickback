//
//  Queue.swift
//  Kickback
//
//  Created by Katie Jiang on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import Foundation
import Parse

class Queue {
    
    // Properties
    var id: String
    var owner: User
    var accessCode: String
    var tracks: [Track]
    var counts: [String: Int] // user id : number of songs user has played
    var members: [String] // user ids, might not be necessary with the counts dictionary?
    var playIndex: Int // index of current playing track
    var currentTrack: Track?
    var parseQueue: PFObject
    
    // Create initializer with dictionary
    init(owner: User) {
        let queue = PFObject(className: "Queue")
        self.id = queue.objectId!
        self.owner = owner
        self.accessCode = Queue.generateAccessCode()
        queue["tracks"] = self.tracks
        queue["counts"] = [:] // add owner id
        queue["members"] = [] // add owner id
        queue["playIndex"] = -1
        queue["currentTrack"] = nil
        queue.saveInBackground()
        self.parseQueue = queue
        updateFromParse()
    }
    
    func updateFromParse() {
        queue.fetch()
        self.tracks = queue["tracks"] as! [Track]
        self.counts = queue["counts"] as! [String: Int]
        self.members = queue["members"] as! [String]
        self.playIndex = queue["playIndex"] as! Int
        self.currentTrack = queue["currentTrack"] as? Track
    }
    
    
    private static func generateAccessCode() -> String {
        var code = ""
        let possible : NSString = "abcdefghijklmnopqrstuvwxyz"
        // TODO: check if access code already exists
        for _ in 1...6 {
            let random = arc4random_uniform(UInt32(possible.length))
            var char = possible.character(at: Int(random))
            code += NSString(characters: &char, length: 1) as String
        }
        return code
    }
}
