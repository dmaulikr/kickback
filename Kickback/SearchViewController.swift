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
    var searchText: String!

    var tracks: [Track] = []
    var artists: [Artist] = []
    var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.isHidden = true
        segmentedControl.isHidden = true
        
        // Set up instructions
        findMusicLabel.text = "Search for songs, artists, albums,\nplaylists, and profiles."
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        // Set up the segemented control
        segmentBottomBorder.borderColor = UIColor.white.cgColor
        segmentBottomBorder.borderWidth = 4
        segmentedControlBorder(sender: segmentedControl)
        let titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.isHidden = tracks.isEmpty && artists.isEmpty && albums.isEmpty
        self.segmentedControl.isHidden =  tracks.isEmpty && artists.isEmpty && albums.isEmpty
        
        self.navigationController?.isNavigationBarHidden = true
  
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
        case 3:
            APIManager.current?.searchTracks(query: searchText, user: User.current, callback: { (tracks) in
                //      self.tracks = tracks
                //       self.tableView.reloadData()
            })
        default:
            break
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return tracks.count
        case 1:
            return artists.count
        case 2:
            return albums.count
        case 3:
            return tracks.count
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
            cell = searchCell as SearchResultCell
        case 1:
            let artistCell = tableView.dequeueReusableCell(withIdentifier: "ArtistResultCell", for: indexPath) as! ArtistResultCell
            artistCell.artistCellButton.tag = indexPath.row
            artistCell.artist = artists[indexPath.row]
            cell = artistCell as ArtistResultCell
        case 2:
            let albumCell = tableView.dequeueReusableCell(withIdentifier: "AlbumResultCell", for: indexPath) as! AlbumResultCell
            albumCell.albumCellButton.tag = indexPath.row
            albumCell.album = albums[indexPath.row]
            cell = albumCell as AlbumResultCell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
            cell.track = tracks[indexPath.row]
            return cell
        default:
            break
        }
        return cell
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
                    print(artists)
                    self.artists = artists
                    self.tableView.reloadData()
                })
            case 2:
                APIManager.current?.searchAlbums(query: searchText, user: User.current, callback: { (albums) in
                    self.albums = albums
                    self.tableView.reloadData()
                })
            case 3:
                APIManager.current?.searchTracks(query: searchText, user: User.current, callback: { (tracks) in
              //      self.tracks = tracks
             //       self.tableView.reloadData()
                })
            default:
                break;
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
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
        case 3:
            APIManager.current?.searchTracks(query: searchText, user: User.current, callback: { (tracks) in
                //      self.tracks = tracks
                //       self.tableView.reloadData()
            })
        default:
            break
        }
    }
    
    func segmentedControlBorder(sender: UISegmentedControl) {
        let width: CGFloat = sender.frame.size.width/4
        let x = CGFloat(sender.selectedSegmentIndex) * width
        let y = sender.frame.size.height - (segmentBottomBorder.borderWidth)
        segmentBottomBorder.frame = CGRect(x: x, y: y, width: width, height: (segmentBottomBorder.borderWidth))
        sender.layer.addSublayer(segmentBottomBorder)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "albumSegue" {
            let button = sender as! UIButton
            let album = albums[button.tag]
            let albumViewController = segue.destination as! AlbumViewController
            albumViewController.album = album
        }
        if segue.identifier == "artistSegue" {
            let button = sender as! UIButton
            let artist = artists[button.tag]
            let artistViewController = segue.destination as! ArtistViewController
            artistViewController.artist = artist
        }
    }
}
