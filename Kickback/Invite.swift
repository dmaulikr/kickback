//
//  Invite.swift
//  Kickback
//
//  Created by Katie Jiang on 7/26/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import Foundation
import Parse

class Invite {
    
    var queueName: String
    var inviterName: String?
    var inviterId: String
    var queueCode: String
    var inviteeId: String
    var queueId: String
    
    init(_ parseInvite: PFObject) {
        queueName = parseInvite["queueName"] as! String
        inviterName = parseInvite["inviterName"] as? String
        inviterId = parseInvite["inviterId"] as! String
        queueCode = parseInvite["queueCode"] as! String
        inviteeId = parseInvite["inviteeId"] as! String
        queueId = parseInvite["queueId"] as! String
    }
    
    static func addInvite(queue: Queue, inviteeId: String, inviter: User) {
        var dictionary: [String: Any] = [:]
        dictionary["queueId"] = queue.id
        dictionary["queueName"] = queue.name
        dictionary["queueCode"] = queue.accessCode
        dictionary["inviteeId"] = inviteeId
        dictionary["inviterName"] = inviter.name
        dictionary["inviterId"] = inviter.id
        let invite = PFObject(className: "Invite", dictionary: dictionary)
        invite.saveInBackground()
    }
    
    static func removeInvite(queueId: String, userId: String) {
        let query = PFQuery(className: "Invite").whereKey("queueId", equalTo: queueId).whereKey("userId", equalTo: userId)
        if query.countObjects(nil) > 0 {
            query.getFirstObjectInBackground(block: { (result, error) in
                if let error = error {
                    print("Error removing invite: \(error.localizedDescription)")
                } else {
                    result!.deleteInBackground()
                }
            })
        }
    }
}
