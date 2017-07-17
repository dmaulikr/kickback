//
//  TrackCell.swift
//  Kickback
//
//  Created by Daniel Afolabi on 7/16/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
 //   @IBOutlet weak var artistsLabel: UILabel!
    
    var track: Track! {
        didSet {
            nameLabel.text = track.name
            
//            if track.artists.count == 1 {
//                artistsLabel.text = track.artists[0]
//            } else {
//                for artist in track.artists {
//                    artistsLabel.text = artistsLabel.text + artist.name + ","
//                }
//            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
