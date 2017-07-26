//
//  ArtistResultCell.swift
//  Kickback
//
//  Created by Daniel Afolabi on 7/25/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class ArtistResultCell: UITableViewCell {

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var artistCellButton: UIButton!
    
    var artist: Artist! {
        didSet {
            // Setting up the artist name
            artistNameLabel.text = artist.name
            
            // Set the image of the aertist
            let imageDictionary = artist.images
            let url = URL(string: imageDictionary[0]["url"] as! String)
            artistImageView.af_setImage(withURL: url!)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        artistImageView.layer.borderWidth = 1
        artistImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
