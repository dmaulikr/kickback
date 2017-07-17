//
//  LoginViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    let manager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "Get ready to kickback to \nmusic with your friends."
        
        // Set up Login Button
        loginButton.layer.cornerRadius = loginButton.frame.width * 0.10
        loginButton.layer.masksToBounds = true
        
        APIManager.current = manager
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        if UIApplication.shared.openURL(manager.loginURL!) {
            if manager.auth.canHandle(manager.auth.redirectURL) {
                     NotificationCenter.default.addObserver(self, selector: #selector(readyforSegue), name: Notification.Name("loginSuccessful"), object: nil)
            }
        }
    }
    
    func readyforSegue() {
        performSegue(withIdentifier: "loginSegue", sender: self)
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
