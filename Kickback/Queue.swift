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
    var id: String!
    var ownerId: String
    var accessCode: String
    var name: String // name of queue
    var tracks: [Track]
    var counts: [String: Int] // user id : number of songs user has played
    var members: [String] // user ids, might not be necessary with the counts dictionary?
    var playIndex: Int // index of current playing track
    var currentTrack: Track?
    var parseQueue: PFObject
    
    private static var _current: Queue?
    static var current: Queue? {
        get {
            if _current == nil {
                if let queueId = User.current?.queueId {
                    let parseQueue = try! PFQuery(className: "Queue").getObjectWithId(queueId)
                    _current = Queue(parseQueue)
                }
            }
            return _current
        }
        set (newQueue) {
            _current = newQueue
        }
    }
    
    // Create initializer
    init(owner: User, name: String) {
        let queue = PFObject(className: "Queue")
        self.ownerId = owner.id
        self.accessCode = Queue.generateAccessCode()
        if name.characters.count == 0 {
            self.name = "New Playlist"
        } else {
            self.name = name
        }
        self.tracks = []
        self.counts = [owner.id: 0]
        self.members = [owner.id]
        self.playIndex = 0
        queue["ownerId"] = self.ownerId
        queue["accessCode"] = self.accessCode
        queue["name"] = self.name
        queue["jsonTracks"] = [] as! [[String: Any]]
        queue["counts"] = self.counts
        queue["members"] = self.members
        queue["playIndex"] = self.playIndex
        self.parseQueue = queue
        queue.saveInBackground { (success: Bool, error: Error?) in
            if success {
                self.id = self.parseQueue.objectId!
                owner.add(queueId: self.id)
                User.current = owner
                print(User.current!.queueId!)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    init(_ parseQueue: PFObject) {
        self.parseQueue = parseQueue
        self.id = parseQueue.objectId
        self.ownerId = parseQueue["ownerId"] as! String
        self.accessCode = parseQueue["accessCode"] as! String
        self.name = parseQueue["name"] as! String
        let jsonTracks = parseQueue["jsonTracks"] as! [[String: Any]]
        self.tracks = []
        for jsonTrack in jsonTracks {
            self.tracks.append(Track(jsonTrack))
        }
        self.counts = parseQueue["counts"] as! [String: Int]
        self.members = parseQueue["members"] as! [String]
        self.playIndex = parseQueue["playIndex"] as! Int
    }
    
    func updateFromParse() {
        do {
            try parseQueue.fetch()
            self.id = parseQueue.objectId
            self.ownerId = parseQueue["ownerId"] as! String
            self.accessCode = parseQueue["accessCode"] as! String
            self.name = parseQueue["name"] as! String
            let jsonTracks = parseQueue["jsonTracks"] as! [[String: Any]]
            self.tracks = []
            for jsonTrack in jsonTracks {
                self.tracks.append(Track(jsonTrack))
            }
            self.counts = parseQueue["counts"] as! [String: Int]
            self.members = parseQueue["members"] as! [String]
            self.playIndex = parseQueue["playIndex"] as! Int
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
        track.userId = user.id
        updateFromParse()
        tracks.append(track)
        parseQueue.add(track.dictionary, forKey: "jsonTracks")
        // reorder the tracks as needed (we might need to use a heap)
        counts[track.userId!]! += 1
        parseQueue["counts"] = counts
        parseQueue.saveInBackground()
    }
    
    func renameTo(_ newName: String) {
        self.name = newName
        parseQueue["name"] = newName
        parseQueue.saveInBackground()
    }
    
    func incrementPlayIndex() {
        playIndex += 1
        parseQueue["playIndex"] = playIndex
        parseQueue.saveInBackground()
    }
    
    func decrementPlayIndex() {
        playIndex -= 1
        parseQueue["playIndex"] = playIndex
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
