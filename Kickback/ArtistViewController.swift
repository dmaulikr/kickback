//
//  ArtistViewController.swift
//  Kickback
//
//  Created by Tavis Thompson on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var track: Track!
    var topTracks: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let imageDictionary = track.album["images"] as! [[String: Any]]
        let url = URL(string: imageDictionary[0]["url"] as! String)
        backgroundImageView.af_setImage(withURL: url!)
    
        nameLabel.text = track.artists[0]["name"] as! String
        
        let artistURI = track.artists[0]["uri"] as! String
        APIManager.current?.topTracks(artistURI: URL(string: artistURI)!, user: User.current, callback: { (topTracks) in
            self.topTracks = topTracks
            self.tableView.reloadData()
        })
        
/*     songLabel.text = track.name
 if artists.count > 1 {
 var artistNames: [String] = []
 for i in 1..<artists.count {
 let name = artists[i]["name"] as! String
 artistNames.append(name)
 }
 }
 songLabel.text = songLabel.text + "(with " + artistNames.joined(separator: ", ") + ")" */

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
