//
//  CreateHomeViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class CreateHomeViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {

    @IBOutlet weak var playlistNameLabel: UILabel!
    
    @IBOutlet weak var previousSongImageView: UIImageView!
    @IBOutlet weak var currentSongImageView: UIImageView!
    @IBOutlet weak var nextSongImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addToPlaylistButton: UIButton!
    
    var manager = APIManager.current!
    var player: SPTAudioStreamingController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Add to Playlist Button
        addToPlaylistButton.layer.cornerRadius = addToPlaylistButton.frame.width * 0.10
        addToPlaylistButton.layer.masksToBounds = true
        
        // Initialize Spotify player
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player.playbackDelegate = self
            self.player.delegate = self
            try! player.start(withClientId: manager.auth.clientID)
            self.player.login(withAccessToken: manager.session.accessToken)
        }
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
    
    @IBAction func didTapAddtoPlaylist(_ sender: Any) {
        performSegue(withIdentifier: "searchSegue", sender: self)

    }

    @IBAction func didTapNext(_ sender: Any) {
    }
    
    @IBAction func didTapPlayPause(_ sender: Any) {
        let resume = !player.playbackState.isPlaying
        player.setIsPlaying(resume) { (error: Error?) in
            print(error?.localizedDescription)
        }
    }
    
    @IBAction func didTapRewind(_ sender: Any) {
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:4jJIWz41sPgzlgnxegAI7c", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing")
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
