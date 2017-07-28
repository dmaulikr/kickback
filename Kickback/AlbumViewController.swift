//
//  AlbumViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    var album: Album!
    var track: Track!
    var tracks: [Track] = []
    
    var addedtoQueue: [Bool]!
    
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
        }
        
        // Setting up the album title
        albumNameLabel.text = album.name
        let artistName = album.artists
        artistNameButton.setTitle(artistName[0]["name"] as! String?, for: .normal)
        
        // Setting up the album picture
        let imageDictionary = album.images
        let url = URL(string: imageDictionary[0]["url"] as! String)
        profileImageView.af_setImage(withURL: url!)
        
        // Setting up the album image
        let albumURI = album.uri
        APIManager.current?.getTracksInAlbum(albumURI: URL(string: albumURI)!, user: User.current, callback: { (tracks) in
            self.tracks = tracks
            self.tableView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Set up black navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.black
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
            cell.addTrackButton.addTarget(self, action: #selector(self.buttonAction(sender:)),
                                          for: UIControlEvents.touchUpInside)
            cell.addTrackButton.tag = indexPath.row
            
            // Reset the reuse cell
            cell.nameLabel.textColor = UIColor.white
            cell.albumImageView.layer.borderWidth = 1
            cell.addTrackButton.isHidden = false
            
            if addedtoQueue[indexPath.row] == true {
                // disable State Button
                cell.addTrackButton.isEnabled = false
                
            } else {
                // activate State Button
                cell.addTrackButton.isEnabled = true
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
                
                cell.addTrackButton.isHidden = true
                cell.addTrackButton.isEnabled = false
                
            } else {
                self.tracks = tracks.filter({ (dictionary) -> Bool in
                    if let value = dictionary.name as? String {
                        return value != track.name
                    }
                    return false
                })
                cell.track = self.tracks[indexPath.row]
                cell.addTrackButton.addTarget(self, action: #selector(self.buttonAction(sender:)),
                                              for: UIControlEvents.touchUpInside)
                cell.addTrackButton.tag = indexPath.row
                
                // Reset the reuse cell
                cell.nameLabel.textColor = UIColor.white
                cell.albumImageView.layer.borderWidth = 1
                cell.addTrackButton.isHidden = false
                
                if addedtoQueue[indexPath.row] == true {
                    // disable State Button
                    cell.addTrackButton.isEnabled = false
                    
                } else {
                    // activate State Button
                    cell.addTrackButton.isEnabled = true
                }
            }
        }
        return cell
    }
    
    func buttonAction(sender:UIButton!) {
        let index = sender.tag
        if addedtoQueue[index] == false {
            addedtoQueue[index] = true
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let artistViewController = segue.destination as! ArtistViewController
        artistViewController.album = album
    }
}
