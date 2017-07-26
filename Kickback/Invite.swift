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
    
    var userId: String!
    var queueId: String!
    
    static func addInvite(queueId: String, userId: String) {
        var dictionary: [String: Any] = [:]
        dictionary["queueId"] = queueId
        dictionary["userId"] = userId
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
