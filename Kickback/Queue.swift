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
    
    // Create initializer
    init(owner: User) {
        let queue = PFObject(className: "Queue")
        self.id = queue.objectId!
        self.owner = owner
        self.accessCode = Queue.generateAccessCode()
        self.tracks = []
        self.counts = [owner.id: 0]
        self.members = [owner.id]
        self.playIndex = -1
        self.currentTrack = nil
        queue["tracks"] = self.tracks
        queue["counts"] = self.counts
        queue["members"] = self.members
        queue["playIndex"] = self.playIndex
        queue["currentTrack"] = self.currentTrack
        queue.saveInBackground()
        self.parseQueue = queue
    }
    
    func updateFromParse() {
        do {
            try parseQueue.fetch()
            self.tracks = parseQueue["tracks"] as! [Track]
            self.counts = parseQueue["counts"] as! [String: Int]
            self.members = parseQueue["members"] as! [String]
            self.playIndex = parseQueue["playIndex"] as! Int
            self.currentTrack = parseQueue["currentTrack"] as? Track
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addMember(userId: String) {
        if !members.contains(userId) {
            updateFromParse()
            members.append(userId)
            parseQueue.add(userId, forKey: "members")
            counts[userId] = 0
            parseQueue["counts"] = counts
            parseQueue.saveInBackground()
        }
    }
    
    func removeMember(userId: String) {
        if members.contains(userId) {
            updateFromParse()
            members = members.filter() {$0 != userId}
            parseQueue.remove(userId, forKey: "members")
            counts.removeValue(forKey: userId)
            parseQueue["counts"] = counts
            parseQueue.saveInBackground()
        }
    }
    
    func addTrack(_ track: Track, user: User) {
        track.queuedBy = user
        updateFromParse()
        tracks.append(track)
        parseQueue.add(track, forKey: "tracks")
        // reorder the tracks as needed (we might need to use a heap)
        counts[track.queuedBy!.id]! += 1
        parseQueue["counts"] = counts
        parseQueue.saveInBackground()
    }
    
    private static func generateAccessCode() -> String {
        let possible : NSString = "abcdefghijklmnopqrstuvwxyz"
        var codeExists = true
        var code: String = ""
        while codeExists {
            code = ""
            for _ in 1...6 {
                let random = arc4random_uniform(UInt32(possible.length))
                var char = possible.character(at: Int(random))
                code += NSString(characters: &char, length: 1) as String
            }
            let query = PFQuery(className: "Queue").whereKey("accessCode", equalTo: code)
            if query.countObjects(nil) == 0 {
                codeExists = false
            }
        }
        return code
    }
}
