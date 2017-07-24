//
//  TrackCell.swift
//  Kickback
//
//  Created by Katie Jiang on 7/20/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit
import SwipeCellKit

class TrackCell: SwipeTableViewCell {
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistsLabel: UILabel!
    
    var animator: Any?
    
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
    var liked = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setLiked(_ liked: Bool, animated: Bool) {
        if #available(iOS 10, *), animated {
            var localAnimator = self.animator as? UIViewPropertyAnimator
            localAnimator?.stopAnimation(true)
            localAnimator = liked ? UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.4, animations: nil) : UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1.0, animations: nil)
            localAnimator?.addAnimations {
                self.liked = liked
            }
            localAnimator?.startAnimation()
        } else {
            self.liked = liked
        }
    }
}

enum ActionDescriptor {
    case like, unlike
    
    func title() -> String? {
        switch self {
        case .like: return "Like"
        case .unlike: return "Unlike"
        }
    }
    
    func image() -> UIImage? {
        return #imageLiteral(resourceName: "heart")
    }
    
    var color: UIColor {
        return UIColor.red
    }
}
