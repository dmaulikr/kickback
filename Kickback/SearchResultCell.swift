//
//  SearchResultCell.swift
//  Kickback
//
//  Created by Daniel Afolabi on 7/16/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistsLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    var track: Track! {
        didSet {
            nameLabel.text = track.name
            
            // Setting up artist label
            if track.artists.count == 1 {
                artistsLabel.text = track.artists[0]["name"] as! String
            } else {
                artistsLabel.text = ""
                
                for i in 0 ..< track.artists.count {
                    if i == track.artists.count - 1 {
                        artistsLabel.text = artistsLabel.text! +  " " + (track.artists[i]["name"] as! String)
                    } else {
                        artistsLabel.text = artistsLabel.text! +  " " + (track.artists[i]["name"] as! String) + ", "
                    }
                }
            }
            
            // Setting up the album image
            let imageDict = track.album["images"] as! [[String: Any]]
            let url = URL(string: imageDict[0]["url"] as! String)
            albumImageView.af_setImage(withURL: url!)
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        albumImageView.layer.borderWidth = 1
        albumImageView.layer.borderColor = UIColor.white.cgColor
//        albumImageView.layer.borderColor = 
    }
    
    @IBAction func onAddTrack(_ sender: Any) {
        Queue.current!.addTrack(track, user: User.current!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
