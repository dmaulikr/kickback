//
//  AlbumViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit
import CoreImage

class AlbumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameButton: UIButton!
    @IBOutlet weak var background_Image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var album: Album!
    var track: Track!
    var tracks: [Track] = []
    var context = CIContext(options: nil)

    var addedtoQueue: [Bool]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationController!.navigationBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.tintColor = UIColor.white
        self.navigationController?.view.backgroundColor = .clear
        
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
        }
        
        // Setting up the album title
        albumNameLabel.text = album.name
        let artistName = album.artists
        artistNameButton.setTitle(artistName[0]["name"] as! String?, for: .normal)
        
        // Setting up the album picture
        let imageDictionary = album.images
        let url = URL(string: imageDictionary[0]["url"] as! String)
        profileImageView.af_setImage(withURL: url!)
        background_Image.af_setImage(withURL: url!)
        
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
        addedtoQueue = [Bool](repeating: false, count: tracks.count)
        if track == nil {
            return tracks.count
        }
        return tracks.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        if track == nil {
            cell.track = self.tracks[indexPath.row]
            // Reset the reuse cell
            cell.nameLabel.textColor = UIColor.white
            cell.albumImageView.layer.borderWidth = 1
            cell.addTrackImageView.isHidden = false
            
            if addedtoQueue[indexPath.row] {
                // indicate track has been added
                cell.addTrackImageView.image = UIImage(named: "check")
            } else {
                // indicate track has not been added
                cell.addTrackImageView.image = UIImage(named: "plus")
            }
        } else {
            if indexPath.row == 0 {
                // Setting up the current track
                cell.nameLabel.text = track.name
                cell.nameLabel.textColor = UIColor(red:0.56, green:0.07, blue:1.00, alpha:1.0)
                let artists = track.artists
                var artistNames: [String] = []
                for i in 0..<artists.count {
                    let name = artists[i]["name"] as! String
                    artistNames.append(name)
                }
                cell.artistsLabel.text = artistNames.joined(separator: ", ")
                
                // Setting up the album picture
                let imageDictionary = album.images
                let url = URL(string: imageDictionary[0]["url"] as! String)
                profileImageView.af_setImage(withURL: url!)
                cell.albumImageView.af_setImage(withURL: url!)
                cell.albumImageView.layer.borderWidth = 0
                
                cell.addTrackImageView.isHidden = true                
            } else {
                self.tracks = tracks.filter({ (dictionary) -> Bool in
                    if let value = dictionary.name as? String {
                        return value != track.name
                    }
                    return false
                })
                cell.track = self.tracks[indexPath.row]
                // Reset the reuse cell
                cell.nameLabel.textColor = UIColor.white
                cell.albumImageView.layer.borderWidth = 1
                cell.addTrackImageView.isHidden = false
                
                if addedtoQueue[indexPath.row] {
                    // indicate track has been added
                    cell.addTrackImageView.image = UIImage(named: "check")
                } else {
                    // indicate track has not been added
                    cell.addTrackImageView.image = UIImage(named: "plus")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get the track
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        cell.track = tracks[indexPath.row]
        
        // reload tableview
        addedtoQueue[indexPath.row] = true
        tableView.reloadData()
        
        // add track to playlist
        Queue.current!.addTrack(track, user: User.current!)
    }
       // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let artistViewController = segue.destination as! ArtistViewController
        artistViewController.album = album
    }
}
