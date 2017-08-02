//
//  AccessCodeViewController.swift
//  Kickback
//
//  Created by Katie Jiang on 7/27/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit
import Parse
import SkyFloatingLabelTextField

class AccessCodeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var accessCodeTextField: SkyFloatingLabelTextField!
    var user = User.current!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        accessCodeTextField.becomeFirstResponder()
        accessCodeTextField.delegate = self
        accessCodeTextField.placeholderFont = UIFont(name: "HKGrotesk-SemiBold", size: 26)
        accessCodeTextField.placeholderColor = UIColor.lightText
        accessCodeTextField.selectedTitleColor = UIColor(red:0.42, green:0.11, blue:0.60, alpha:1.0)
        accessCodeTextField.font = UIFont(name: "HKGrotesk-SemiBold", size: 26)
        
        // change the color of the back button in the navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapJoin(_ sender: Any) {
        if let code = accessCodeTextField.text {
            tryJoinQueueWith(code: code.lowercased())
        }
    }
    
    func tryJoinQueueWith(code: String) {
        let query = PFQuery(className: "Queue").whereKey("accessCode", equalTo: code)
        query.getFirstObjectInBackground(block: { (parseQueue: PFObject?, error: Error?) in
            if let error = error {
                // There is no queue with that access code.
                
                // create the alert
                let alert = UIAlertController(title: "Invalid Playlist Code", message: "We can't find a playlist with this code. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                print(error.localizedDescription)
            } else {
                let queue = Queue(parseQueue!)
                queue.addMember(userId: self.user.id)
                self.user.add(queueId: queue.id)
                self.performSegue(withIdentifier: "joinSuccessSegue", sender: self)
                Queue.current = queue
            }
        })
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
