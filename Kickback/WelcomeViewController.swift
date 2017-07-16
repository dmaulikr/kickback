//
//  HomeViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBOutlet weak var joinPlaylistButton: UIButton!
    @IBOutlet weak var createPlaylistButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.purple]

        // Set up the profile image
        let url = URL(string: (User.current?.profileImageURL)!)
        // Set up the profile image to be a perfect circle
        profileImage.af_setImage(withURL: url!)
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.masksToBounds = false
        profileImage.clipsToBounds = true

//        profileImage.layer.cornerRadius = profileImage.frame.width * 0.40
//        profileImage.layer.masksToBounds = true
//        
        // Set up Join Playlist Button
        joinPlaylistButton.layer.cornerRadius = joinPlaylistButton.frame.width * 0.10
        joinPlaylistButton.layer.masksToBounds = true
        
        // Set up Create Playlist Button
        createPlaylistButton.layer.cornerRadius = createPlaylistButton.frame.width * 0.10
        createPlaylistButton.layer.masksToBounds = true
    
        // Set up text for the screen
        welcomeLabel.text = "Welcome, " + (User.current?.name)!
        instructionsLabel.text = "Create a playlist and invite others, \nor join a playlist with a playlist code."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCreate(_ sender: Any) {
        performSegue(withIdentifier: "createSegue", sender: self)
    }
    
    @IBAction func didTapJoin(_ sender: Any) {
        performSegue(withIdentifier: "joinSegue", sender: self)
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        performSegue(withIdentifier: "logoutSegue", sender: self)
        
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
