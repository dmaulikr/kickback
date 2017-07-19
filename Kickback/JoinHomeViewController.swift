//
//  JoinHomeViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class JoinHomeViewController: UIViewController {

    @IBOutlet weak var playlistNameLabel: UILabel!
    
    @IBOutlet weak var previousSongImageView: UIImageView!
    @IBOutlet weak var currentSongImageView: UIImageView!
    @IBOutlet weak var nextSongImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set up clear navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTapLeave(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to leave this playlist?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Leave Playlist", style: .destructive) { (action) in
            Queue.current = nil
            User.leaveQueue()
            self.performSegue(withIdentifier: "leaveSegue", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (action) in
        }
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true) {
            // what happens after the alert controller has finished presenting
        }
    }

}
