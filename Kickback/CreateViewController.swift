//
//  CreateQViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CreateViewController: UIViewController, UITextFieldDelegate {
    
    var user = User.current!
    
    @IBOutlet weak var playlistTextField: SkyFloatingLabelTextField!
    var placeholderLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlistTextField.becomeFirstResponder()
        playlistTextField.delegate = self
        playlistTextField.placeholderFont = UIFont(name: "HKGrotesk-SemiBold", size: 26)
        playlistTextField.placeholderColor = UIColor.lightText
        playlistTextField.selectedTitleColor = UIColor(red:0.42, green:0.11, blue:0.60, alpha:1.0)
        playlistTextField.font = UIFont(name: "HKGrotesk-SemiBold", size: 26)
        
        // change the color of the back button in the navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.title = "Create Playlist"
    }
    
    
    
//    func textViewDidChange(_ textView: UITextView) {
//        placeholderLabel.isHidden = !textView.text.isEmpty
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCreate(_ sender: Any) {
        let queue = Queue(owner: user, name: playlistTextField.text!)
        Queue.current = queue
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
