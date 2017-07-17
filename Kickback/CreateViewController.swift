//
//  CreateQViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var playlistTextView: UITextView!
    var user = User.current!
    
    var placeholderLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.purple]
//        playlistNameField.attributedPlaceholder = NSAttributedString(string: "Name your playlist",
//                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        // placeholder text
        playlistTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Name your playlist..."
//        placeholderLabel.font = UIFont.
//            UIFont(fontWithName:@"Arial" size:50)

        placeholderLabel.sizeToFit()
        playlistTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (playlistTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !playlistTextView.text.isEmpty
        
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
    
    @IBAction func didTapCreate(_ sender: Any) {
        let queue = Queue(owner: user, name: playlistNameField.text!)
        performSegue(withIdentifier: "createSuccessSegue", sender: self)
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
