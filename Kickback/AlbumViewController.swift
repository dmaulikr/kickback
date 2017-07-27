//
//  AlbumViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var currentTrackImageView: UIImageView!
    @IBOutlet weak var currentTrackNameLabel: UILabel!
    @IBOutlet weak var currentTrackArtistNameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    var album: Album!
    var track: Track!
    var tracks: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if track != nil {
            var dictionary: [String: Any] = [:]
            dictionary["id"] = track.album["id"]
            dictionary["name"] = track.album["name"]
            dictionary["images"] =  track.album["images"]
            dictionary["artists"] = track.album["artists"]
            dictionary["userId"] = User.current?.id
            dictionary["uri"] = track.album["uri"]
            album = Album(dictionary)

            // Setting up the current track
            currentTrackNameLabel.text = track.name
            let artists = track.artists
            var artistNames: [String] = []
            for i in 0..<artists.count {
                let name = artists[i]["name"] as! String
                artistNames.append(name)
            }
            currentTrackArtistNameLabel.text = artistNames.joined(separator: ", ")
        } else {
            currentTrackImageView.isHidden = true
            currentTrackNameLabel.isHidden = true
            currentTrackArtistNameLabel.isHidden = true
        }
        
        // Setting up the album title
        albumNameLabel.text = album.name
        let artistName = album.artists
        artistNameButton.setTitle(artistName[0]["name"] as! String?, for: .normal)
        
        // Setting up the album picture
        let imageDictionary = album.images
        let url = URL(string: imageDictionary[0]["url"] as! String)
        profileImageView.af_setImage(withURL: url!)
        currentTrackImageView.af_setImage(withURL: url!)
        
        // Setting up the album image
        let albumURI = album.uri
        APIManager.current?.getTracksInAlbum(albumURI: URL(string: albumURI)!, user: User.current, callback: { (tracks) in
            self.tracks = tracks
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        
        self.tracks = tracks.filter({ (dictionary) -> Bool in
            if let value = dictionary.name as? String {
                return value != currentTrackNameLabel.text
            }
            return false
        })
        
        cell.track = self.tracks[indexPath.row]
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let artistViewController = segue.destination as! ArtistViewController
        artistViewController.album = album
    }
}
