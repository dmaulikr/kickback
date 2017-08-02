//
//  AddFriendsViewController.swift
//  Kickback
//
//  Created by Katie Jiang on 7/25/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit
import Parse
import SkyFloatingLabelTextField

class AddFriendsViewController: UIViewController{

    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text field set up
        usernameTextField.becomeFirstResponder()
        usernameTextField.placeholderFont = UIFont(name: "HKGrotesk-SemiBold", size: 26)
        usernameTextField.placeholderColor = UIColor.lightText
        usernameTextField.selectedTitleColor = UIColor(red:0.42, green:0.11, blue:0.60, alpha:1.0)
        usernameTextField.font = UIFont(name: "HKGrotesk-SemiBold", size: 26)
        
        // Change the color of the back button in the navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.title = "Add Friends"
        
        // Style add friend button
        addFriendButton.layer.cornerRadius = addFriendButton.frame.width * 0.10
        addFriendButton.layer.masksToBounds = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAdd(_ sender: Any) {
        if let userId = usernameTextField.text {
            let userQuery = PFQuery(className: "SPTUser").whereKey("id", equalTo: userId)
            if userQuery.countObjects(nil) > 0 {
                let inviteQuery = PFQuery(className: "Invite").whereKey("queueId", equalTo: Queue.current!.id).whereKey("userId", equalTo: userId)
                if inviteQuery.countObjects(nil) == 0 {
                    Invite.addInvite(queue: Queue.current!, inviteeId: userId, inviter: User.current!)
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
