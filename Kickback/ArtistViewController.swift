//
//  ArtistViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var track: Track!
    var topTracks: [Track] = []
    var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let imageDictionary = track.album["images"] as! [[String: Any]]
        let url = URL(string: imageDictionary[0]["url"] as! String)
        backgroundImageView.af_setImage(withURL: url!)
        
        nameLabel.text = track.artists[0]["name"] as! String
        
        let artistURI = track.artists[0]["uri"] as! String
        APIManager.current?.getTopTracks(artistURI: URL(string: artistURI)!, user: User.current, callback: { (topTracks) in
            self.topTracks = topTracks
            self.tableView.reloadData()
        })
        
        APIManager.current?.getAlbumsByArtist(artistURI: URL(string: artistURI)!, user: User.current, callback: { (albums) in
            self.albums = albums
            self.collectionView.reloadData()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        cell.track = topTracks[indexPath.row]
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.album = albums[indexPath.item]
        return cell
        
        
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "albumSegue" {
            let cell = sender as! UICollectionViewCell
            if let indexPath = collectionView.indexPath(for: cell) {
                let album = albums[indexPath.row]
                let albumViewController = segue.destination as! AlbumViewController
                albumViewController.album = album
                albumViewController.track = track
            }
        }
}
