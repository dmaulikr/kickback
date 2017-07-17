//
//  CreateHomeViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class CreateHomeViewController: UIViewController {

    @IBOutlet weak var playlistNameLabel: UILabel!
    
    @IBOutlet weak var previousSongImageView: UIImageView!
    @IBOutlet weak var currentSongImageView: UIImageView!
    @IBOutlet weak var nextSongImageView: UIImageView!
    
    @IBOutlet weak var volumeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.purple]
        // Do any additional setup after loading the view.
        
        let manager = APIManager.current!
        print("searching tracks")
        manager.searchTracks(query: "wild", user: User.current) { (tracks: [Track]) in
            print("got here")
            for track in tracks {
                print(track.name)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func volumeSlider(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        
        volumeLabel.text = "\(currentValue)"
    }

    @IBAction func didTapNext(_ sender: Any) {
    }
    
    @IBAction func didTapPlay(_ sender: Any) {
    }
    
    @IBAction func didTapRewind(_ sender: Any) {
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
