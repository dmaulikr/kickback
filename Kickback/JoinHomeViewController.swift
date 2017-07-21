//
//  JoinHomeViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class JoinHomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {

    @IBOutlet weak var currentSongImageView: UIImageView!
    @IBOutlet weak var nextSongImageView: UIImageView!
    @IBOutlet weak var previousSongImageView: UIImageView!
    
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var addToPlaylistButton: UIButton!

    
    var manager = APIManager.current!
    var player = SPTAudioStreamingController.sharedInstance()!
    var queue: Queue!
    var user: User!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add timer
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
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
        
        // Initialize the table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.clear
        
        self.queue = Queue.current
        self.user = User.current
        
        
        // Refresh control
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set up clear navigation bar
        let navBar = self.navigationController!.navigationBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.topItem?.title = queue.name
        navBar.tintColor = UIColor.white
        self.navigationController?.view.backgroundColor = .clear
        
        loadAlbumDisplays()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if queue.tracks.count <= 1 {
            return 0
        }
        return queue.tracks.count - queue.playIndex - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        cell.track = queue.tracks[queue.playIndex + indexPath.row + 1]
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func onTimer() {
        tableView.reloadData()
    }
    
    func loadAlbumDisplays() {
        // Load current track info
        let tracks = queue.tracks
        let playIndex = queue.playIndex
        if !tracks.isEmpty {
            songLabel.text = tracks[playIndex].name
            let artists = tracks[playIndex].artists
            var artistNames: [String] = []
            for i in 0..<artists.count {
                let name = artists[i]["name"] as! String
                artistNames.append(name)
            }
            artistLabel.text = artistNames.joined(separator: ", ")
            let imageDictionary = tracks[playIndex].album["images"] as! [[String: Any]]
            let url = URL(string: imageDictionary[0]["url"] as! String)!
            currentSongImageView.af_setImage(withURL: url)
        }
        // Load previous track
        if playIndex > 0 {
            let prevTrack = tracks[playIndex - 1]
            let prevImageDictionary = tracks[playIndex - 1].album["images"] as! [[String: Any]]
            let prevUrl = URL(string: prevImageDictionary[0]["url"] as! String)!
            previousSongImageView.af_setImage(withURL: prevUrl)
            previousSongImageView.alpha = 0.5
        } else {
            previousSongImageView.image = nil
        }
        // Load next track
        if playIndex < tracks.count - 1 {
            let nextTrack = tracks[playIndex + 1]
            let nextImageDictionary = tracks[playIndex + 1].album["images"] as! [[String: Any]]
            let nextUrl = URL(string: nextImageDictionary[0]["url"] as! String)!
            nextSongImageView.af_setImage(withURL: nextUrl)
            nextSongImageView.alpha = 0.5
        } else {
            nextSongImageView.image = nil
        }
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
