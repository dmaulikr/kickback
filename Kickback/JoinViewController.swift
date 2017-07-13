//
//  JoinQViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit
import Parse

class JoinViewController: UIViewController {

    var user = User.current!
    @IBOutlet weak var accessCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.purple]
        accessCodeTextField.attributedPlaceholder = NSAttributedString(string: "Put in access code",attributes: [NSForegroundColorAttributeName: UIColor.white])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapJoin(_ sender: Any) {
        if let code = accessCodeTextField.text {
            let query = PFQuery(className: "Queue").whereKey("accessCode", equalTo: code)
            query.getFirstObjectInBackground(block: { (parseQueue: PFObject?, error: Error?) in
                if let error = error {
                    print("Error querying queue with accessCode: \(error.localizedDescription)")
                } else {
                    let queue = Queue(parseQueue!)
                    queue.addMember(userId: self.user.id)
                    self.user.add(queue: queue)
                }
            })
        }
        performSegue(withIdentifier: "toJoinHomeViewController", sender: self)
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
