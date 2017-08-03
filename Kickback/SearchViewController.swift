//
//  SearchViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var findMusicLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let segmentBottomBorder = CALayer()
    var searchText = ""
    var tracks: [Track] = []
    var artists: [Artist] = []
    var albums: [Album] = []
    
    var addedtoQueue: [Bool]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.isHidden = true
        segmentedControl.isHidden = true
        
        // Set up instructions
        findMusicLabel.text = "Search for songs, artists, and albums."
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        searchBar.keyboardAppearance = .dark
        
        // Set up the segemented control
        segmentBottomBorder.borderColor = UIColor.white.cgColor
        segmentBottomBorder.borderWidth = 3
        segmentedControlBorder(sender: segmentedControl)
        let titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.isHidden = tracks.isEmpty && artists.isEmpty && albums.isEmpty
        self.segmentedControl.isHidden =  tracks.isEmpty && artists.isEmpty && albums.isEmpty
        
        self.navigationController?.isNavigationBarHidden = true
        
        if !searchText.characters.isEmpty {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                APIManager.current?.searchTracks(query: searchText, user: User.current, callback: { (tracks) in
                    self.tracks = tracks
                    self.tableView.reloadData()
                })
            case 1:
                APIManager.current?.searchArtists(query: searchText, user: User.current, callback: { (artists) in
                    self.artists = artists
                    self.tableView.reloadData()
                })
            case 2:
                APIManager.current?.searchAlbums(query: searchText, user: User.current, callback: { (albums) in
                    self.albums = albums
                    self.tableView.reloadData()
                })
            default:
                break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            addedtoQueue = [Bool](repeating: false, count: tracks.count)
            return tracks.count
        case 1:
            return artists.count
        case 2:
            return albums.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let searchCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
            searchCell.track = tracks[indexPath.row]
            
            searchCell.addTrackButton.addTarget(self, action: #selector(self.buttonAction(sender:)),
                                                for: UIControlEvents.touchUpInside)
            searchCell.addTrackButton.tag = indexPath.row
            if addedtoQueue[indexPath.row] == true {
                // disable State Button
                searchCell.addTrackButton.isEnabled = false
                
            } else {
                // activate State Button
                searchCell.addTrackButton.isEnabled = true
            }
            cell = searchCell as SearchResultCell
        case 1:
            let artistCell = tableView.dequeueReusableCell(withIdentifier: "ArtistResultCell", for: indexPath) as! ArtistResultCell
            artistCell.artist = artists[indexPath.row]
            cell = artistCell as ArtistResultCell
        case 2:
            let albumCell = tableView.dequeueReusableCell(withIdentifier: "AlbumResultCell", for: indexPath) as! AlbumResultCell
            albumCell.album = albums[indexPath.row]
            cell = albumCell as AlbumResultCell
        default:
            break
        }
        let backgroundColorView = UIView()
        backgroundColorView.backgroundColor = UIColor(red: 0.20, green: 0.07, blue: 0.31, alpha: 1.0)
        cell.selectedBackgroundView = backgroundColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func buttonAction(sender:UIButton!) {
        let index = sender.tag
        if addedtoQueue[index] == false {
            addedtoQueue[index] = true
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.tableView.isHidden = true
            self.segmentedControl.isHidden = true
        }
        else {
            self.tableView.isHidden = false
            self.segmentedControl.isHidden = false
            self.searchText = searchText
            
            switch segmentedControl.selectedSegmentIndex  {
            case 0:
                APIManager.current?.searchTracks(query: searchText, user: User.current, callback: { (tracks) in
                    self.tracks = tracks
                    self.tableView.reloadData()
                })
            case 1:
                APIManager.current?.searchArtists(query: searchText, user: User.current, callback: { (artists) in
                    self.artists = artists
                    self.tableView.reloadData()
                })
            case 2:
                APIManager.current?.searchAlbums(query: searchText, user: User.current, callback: { (albums) in
                    self.albums = albums
                    self.tableView.reloadData()
                })
            default:
                break
            }
        }
    }
    
    @IBAction func onTapCancel(_ sender: Any) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapView(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        segmentedControlBorder(sender: sender)
        if !searchText.characters.isEmpty {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                APIManager.current?.searchTracks(query: searchText, user: User.current, callback: { (tracks) in
                    self.tracks = tracks
                        self.tableView.reloadData()
                })
            case 1:
                APIManager.current?.searchArtists(query: searchText, user: User.current, callback: { (artists) in
                    self.artists = artists
                    self.tableView.reloadData()
                })
            case 2:
                APIManager.current?.searchAlbums(query: searchText, user: User.current, callback: { (albums) in
                    self.albums = albums
                        self.tableView.reloadData()
                })
            default:
                break
            }
        }
    }
    
    func segmentedControlBorder(sender: UISegmentedControl) {
        let width: CGFloat = sender.frame.size.width / 3
        let x = CGFloat(sender.selectedSegmentIndex) * width
        let y = sender.frame.size.height - (segmentBottomBorder.borderWidth)
        segmentBottomBorder.frame = CGRect(x: x, y: y, width: width, height: (segmentBottomBorder.borderWidth))
        sender.layer.addSublayer(segmentBottomBorder)
    }
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        segmentedControl.selectedSegmentIndex = (segmentedControl.selectedSegmentIndex + 1) % segmentedControl.numberOfSegments
        segmentedControlDidChange(segmentedControl)
    }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        segmentedControl.selectedSegmentIndex = (segmentedControl.selectedSegmentIndex - 1) % segmentedControl.numberOfSegments
        if(segmentedControl.selectedSegmentIndex == -1){
            segmentedControl.selectedSegmentIndex = segmentedControl.numberOfSegments-1
        }
        segmentedControlDidChange(segmentedControl)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "albumSegue" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let album = albums[indexPath.row]
                let albumViewController = segue.destination as! AlbumViewController
                albumViewController.album = album
            }
        }
        if segue.identifier == "artistSegue" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let artist = artists[indexPath.row]
                let artistViewController = segue.destination as! ArtistViewController
                artistViewController.artist = artist
            }
        }
    }
}
