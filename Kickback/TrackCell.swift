//
//  TrackCell.swift
//  Kickback
//
//  Created by Katie Jiang on 7/20/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistsLabel: UILabel!
    
    var track: Track! {
        didSet {
            songLabel.text = track.name
            let artists = track.artists
            var artistNames: [String] = []
            for i in 0..<artists.count {
                let name = artists[i]["name"] as! String
                artistNames.append(name)
            }
            artistsLabel.text = artistNames.joined(separator: ", ")
            let imageDictionary = track.album["images"] as! [[String: Any]]
            let url = URL(string: imageDictionary[0]["url"] as! String)
            albumImage.af_setImage(withURL: url!)
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
