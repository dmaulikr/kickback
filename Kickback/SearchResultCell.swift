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
    //   @IBOutlet weak var artistsLabel: UILabel!
    
    var track: Track! {
        didSet {
            nameLabel.text = track.name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onAddTrack(_ sender: Any) {
        Queue.current!.addTrack(track, user: User.current!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
