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
    var queue: Queue!
    var user: User!
    var tracks = ["spotify:track:4jJIWz41sPgzlgnxegAI7c", "spotify:track:4AGgXEtNPFPAMUoDEgjvwX", "spotify:track:7HOpH9FAgS8axilvDU8w6d", "spotify:track:3uA8SjMyDtwtt0jLPMQbVD"]

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
        self.queue = Queue.current
        self.user = User.current
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
        if queue.playIndex == 4 - 1 { // replace the 4 with queue.tracks.count
            player.skipNext(printError(_:))
        } else {
            queue.incrementPlayIndex()
            player.playSpotifyURI(tracks[queue.playIndex], startingWith: 0, startingWithPosition: 0, callback: printError(_:))
        }
    }
    
    @IBAction func didTapPlayPause(_ sender: Any) {
        let resume = !player.playbackState.isPlaying
        player.setIsPlaying(resume, callback: printError(_:))
    }
    
    @IBAction func didTapRewind(_ sender: Any) {
        if queue.playIndex == 0 {
            player.skipPrevious(printError(_:))
        } else {
            queue.decrementPlayIndex()
            player.playSpotifyURI(tracks[queue.playIndex], startingWith: 0, startingWithPosition: 0, callback: printError(_:))
        }
    }
    
    func printError(_ error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        self.player?.playSpotifyURI(tracks[0], startingWith: 0, startingWithPosition: 0, callback: printError(_:))
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
