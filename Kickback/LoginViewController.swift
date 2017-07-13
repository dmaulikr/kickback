//
//  LoginViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let manager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        performSegue(withIdentifier: "toHomeViewController", sender: self)
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
