//
//  JoinQViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit
import Parse

class JoinViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var accessCodeTextView: UITextView!
    
    var user = User.current!
    
    var placeholderLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.purple]
        
        // placeholder text
        accessCodeTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Put in the access code"
        placeholderLabel.sizeToFit()
        accessCodeTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (accessCodeTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !accessCodeTextView.text.isEmpty
        
        // change the color of the cursor
        UITextView.appearance().tintColor = UIColor.purple
        
        // change the color of the back button in the navigation bar
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapJoin(_ sender: Any) {
        if let code = accessCodeTextView.text {
            let query = PFQuery(className: "Queue").whereKey("accessCode", equalTo: code)
            query.getFirstObjectInBackground(block: { (parseQueue: PFObject?, error: Error?) in
                if let error = error {
                    // There is no queue with that access code.
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
