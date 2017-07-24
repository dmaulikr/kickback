//
//  CreateHomeViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.

import UIKit
import SwipeCellKit

class CreateHomeViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var playlistNameLabel: UILabel!
    
    @IBOutlet weak var previousSongImageView: UIImageView!
    @IBOutlet weak var currentSongImageView: UIImageView!
    @IBOutlet weak var nextSongImageView: UIImageView!
    
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addToPlaylistButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    
    var manager = APIManager.current!
    var player = SPTAudioStreamingController.sharedInstance()!
    var queue: Queue!
    var user: User!
    var refreshControl = UIRefreshControl()
    var isSwiping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up timer
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.renderTracks), userInfo: nil, repeats: true)
        
        // Set up Add to Playlist Button
        addToPlaylistButton.layer.cornerRadius = addToPlaylistButton.frame.width * 0.10
        addToPlaylistButton.layer.masksToBounds = true
        
        self.queue = Queue.current
        self.user = User.current
        let isOwner = queue.ownerId == user.id
        playButton.isHidden = !isOwner
        nextButton.isHidden = !isOwner
        rewindButton.isHidden = !isOwner
        if isOwner {
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
            playButton.isSelected = player.playbackState != nil && player.playbackState!.isPlaying
        }
        
        // Initialize the table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.clear
        tableView.allowsSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 66
        view.layoutMargins.left = 32
        
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
        
        renderTracks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if queue.tracks.count <= 1 {
            return 0
        }
        return queue.tracks.count - queue.playIndex - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        cell.track = queue.tracks[queue.playIndex + indexPath.row + 1]
        cell.delegate = self
        cell.selectedBackgroundView = createSelectedBackgroundView()
        return cell
    }
    
    func createSelectedBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return view
    }
    
    // MARK: - Render tracks
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        renderTracks()
        refreshControl.endRefreshing()
    }
    
    func renderTracks() {
        if !isSwiping {
            queue.updateFromParse()
            queue.sortTracks()
            tableView.reloadData()
            loadAlbumDisplays()
        }
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
            artistsLabel.text = artistNames.joined(separator: ", ")
            let imageDictionary = tracks[playIndex].album["images"] as! [[String: Any]]
            let url = URL(string: imageDictionary[0]["url"] as! String)!
            currentSongImageView.af_setImage(withURL: url)
        }
        // Load previous track
        if playIndex > 0 {
            let prevImageDictionary = tracks[playIndex - 1].album["images"] as! [[String: Any]]
            let prevUrl = URL(string: prevImageDictionary[0]["url"] as! String)!
            previousSongImageView.af_setImage(withURL: prevUrl)
            previousSongImageView.alpha = 0.5
        } else {
            previousSongImageView.image = nil
        }
        // Load next track
        if playIndex < tracks.count - 1 {
            let nextImageDictionary = tracks[playIndex + 1].album["images"] as! [[String: Any]]
            let nextUrl = URL(string: nextImageDictionary[0]["url"] as! String)!
            nextSongImageView.af_setImage(withURL: nextUrl)
            nextSongImageView.alpha = 0.5
        } else {
            nextSongImageView.image = nil
        }
    }

    // MARK: - Spotify player
    
    @IBAction func didTapNext(_ sender: Any) {
        playButton.isSelected = true
        let tracks = queue.tracks
        if !tracks.isEmpty {
            if queue.playIndex == tracks.count - 1 {
                player.skipNext(printError(_:))
            } else {
                queue.incrementPlayIndex()
                player.playSpotifyURI(tracks[queue.playIndex].uri, startingWith: 0, startingWithPosition: 0, callback: printError(_:))
                renderTracks()
            }
        }
    }
    
    @IBAction func didTapPlayPause(_ sender: Any) {
        playButton.isSelected = !playButton.isSelected
        let timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
        if !queue.tracks.isEmpty {
            if let playbackState = player.playbackState {
                let resume = !playbackState.isPlaying
                
                player.setIsPlaying(resume, callback: printError(_:))
            } else {
                print(timer)
                self.player.playSpotifyURI(queue.tracks[queue.playIndex].uri, startingWith: 0, startingWithPosition: 0, callback: printError(_:))
            }
        } else {
            print("No tracks to play!")
        }
    }
    
    @objc func update() {
        // Something cool
    }
    
    @IBAction func didTapRewind(_ sender: Any) {
        playButton.isSelected = true
        let tracks = queue.tracks
        if !tracks.isEmpty {
            if queue.playIndex == 0 {
                player.skipPrevious(printError(_:))
            } else {
                queue.decrementPlayIndex()
                player.playSpotifyURI(tracks[queue.playIndex].uri, startingWith: 0, startingWithPosition: 0, callback: printError(_:))
                renderTracks()
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

extension CreateHomeViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let track = queue.tracks[queue.playIndex + indexPath.row + 1]
        if orientation == .right {
            
            let userId = self.user.id
            let like = SwipeAction(style: .default, title: nil, handler: { (action, indexPath) in
                let updatedLikeState = !track.isLikedBy(userId: userId)
                updatedLikeState ? track.like(userId: userId) : track.unlike(userId: userId)
                self.queue.updateTracksToParse()
                
                let cell = tableView.cellForRow(at: indexPath) as! TrackCell
                cell.setLiked(updatedLikeState, animated: true)
            })
            like.hidesWhenSelected = true
            let descriptor = !track.isLikedBy(userId: userId) ? ActionDescriptor.like : ActionDescriptor.unlike
            configure(action: like, with: descriptor)

            return [like]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) {
        isSwiping = orientation == .right
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation) {
        isSwiping = false
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = SwipeExpansionStyle.selection
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title()
        action.image = descriptor.image()
//        action.backgroundColor = descriptor.color
    }
}
