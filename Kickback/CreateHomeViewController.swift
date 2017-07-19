//
//  CreateHomeViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.

import UIKit

class CreateHomeViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {

    @IBOutlet weak var playlistNameLabel: UILabel!
    
    @IBOutlet weak var previousSongImageView: UIImageView!
    @IBOutlet weak var currentSongImageView: UIImageView!
    @IBOutlet weak var nextSongImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addToPlaylistButton: UIButton!
    
    
    var manager = APIManager.current!
    var player = SPTAudioStreamingController.sharedInstance()!
    var queue: Queue!
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Add to Playlist Button
        addToPlaylistButton.layer.cornerRadius = addToPlaylistButton.frame.width * 0.10
        addToPlaylistButton.layer.masksToBounds = true
        
        // Initialize Spotify player
        player.playbackDelegate = self
        player.delegate = self
        if !player.loggedIn {
            do {
                try player.start(withClientId: manager.auth.clientID)
            } catch {
                print(error.localizedDescription)
            }
            self.player.login(withAccessToken: manager.session.accessToken)
        }
        
        self.queue = Queue.current
        self.user = User.current
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Set up clear navigation bar
        let navBar = self.navigationController!.navigationBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.topItem?.title = queue.name
        navBar.tintColor = UIColor.white
        self.navigationController?.view.backgroundColor = .clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapNext(_ sender: Any) {
        let tracks = queue.tracks
        if !tracks.isEmpty {
            if queue.playIndex == tracks.count - 1 {
                player.skipNext(printError(_:))
            } else {
                queue.incrementPlayIndex()
                player.playSpotifyURI(tracks[queue.playIndex].uri, startingWith: 0, startingWithPosition: 0, callback: printError(_:))
            }
        }
    }
    
    @IBAction func didTapPlayPause(_ sender: Any) {
        print(queue.playIndex)
        if !queue.tracks.isEmpty {
            if let playbackState = player.playbackState {
                let resume = !playbackState.isPlaying
                player.setIsPlaying(resume, callback: printError(_:))
            } else {
                self.player.playSpotifyURI(queue.tracks[queue.playIndex].uri, startingWith: 0, startingWithPosition: 0, callback: printError(_:))
            }
        } else {
            print("No tracks to play!")
        }
    }
    
    @IBAction func didTapRewind(_ sender: Any) {
        print(queue.playIndex)
        let tracks = queue.tracks
        if !tracks.isEmpty {
            if queue.playIndex == 0 {
                player.skipPrevious(printError(_:))
            } else {
                queue.decrementPlayIndex()
                player.playSpotifyURI(tracks[queue.playIndex].uri, startingWith: 0, startingWithPosition: 0, callback: printError(_:))
            }
        }
    }
    
    func printError(_ error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
    }

    @IBAction func onTapLeave(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to leave this playlist?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Leave Playlist", style: .destructive) { (action) in
            Queue.current = nil
            User.leaveQueue()
            print(Queue.current)
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
