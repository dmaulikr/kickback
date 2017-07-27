//
//  AddFriendsViewController.swift
//  Kickback
//
//  Created by Katie Jiang on 7/25/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit
import Parse

class AddFriendsViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAdd(_ sender: Any) {
        if let userId = textView.text {
            let userQuery = PFQuery(className: "SPTUser").whereKey("id", equalTo: userId)
            if userQuery.countObjects(nil) > 0 {
                let inviteQuery = PFQuery(className: "Invite").whereKey("queueId", equalTo: Queue.current!.id).whereKey("userId", equalTo: userId)
                if inviteQuery.countObjects(nil) == 0 {
                    Invite.addInvite(queueId: Queue.current!.id, userId: userId)
                    print("invited user")
                } else {
                    print("user has already been invited")
                }
            } else {
                print("user doesn't exist")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
