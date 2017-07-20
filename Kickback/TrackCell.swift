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
    var indicatorView = IndicatorView(frame: CGRect.zero)
    
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
    var liked = false {
        didSet {
            indicatorView.transform = liked ? CGAffineTransform.identity : CGAffineTransform.init(scaleX: 0.001, y: 0.001)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupIndicatorView()
    }
    
    func setupIndicatorView() {
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.color = tintColor
        indicatorView.backgroundColor = .clear
        contentView.addSubview(indicatorView)
        
        let size: CGFloat = 12
        indicatorView.widthAnchor.constraint(equalToConstant: size).isActive = true
        indicatorView.heightAnchor.constraint(equalTo: indicatorView.widthAnchor).isActive = true
        indicatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: songLabel.centerYAnchor).isActive = true
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

class IndicatorView: UIView {
    var color = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        UIBezierPath(ovalIn: rect).fill()
    }
}

enum ActionDescriptor {
    case like
    
    func title() -> String? {
        switch self {
        case .like: return "Like"
        }
    }
    
    func image() -> UIImage? {
        return #imageLiteral(resourceName: "heart")
    }
    
    var color: UIColor {
        switch self {
        case .like: return UIColor.red
        }
    }
}
