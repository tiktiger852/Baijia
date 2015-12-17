//
//  ListCell.swift
//  Baijia
//
//  Created by mac on 11/11/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import Kingfisher

class ListCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var trackCountLabel: UILabel!
    
    var info: Album? {
        didSet {
            self.thumbImageView.kf_setImageWithURL(NSURL(string: self.info!.albumCoverUrl290)!)
            self.titleLabel.text = self.info!.title
            self.descLabel.text = self.info!.intro
            self.playCountLabel.text = self.info!.playsCounts.format
            self.trackCountLabel.text = String(self.info!.tracksCounts) + "集"
        }
    }
    
    override func awakeFromNib() {
        self.separatorInset = UIEdgeInsetsMake(0, 90, 0, 0)
        
        let selectedBackgroundView = UIView(frame: self.contentView.bounds)
        selectedBackgroundView.backgroundColor = RGB(247, 247, 247)
        self.selectedBackgroundView = selectedBackgroundView
        
        self.thumbImageView.layer.borderWidth = 0.5
        self.thumbImageView.layer.borderColor = RGB(234, 234, 234).CGColor
        
        self.titleLabel.textColor = RGB(54, 54, 54)
        self.descLabel.textColor = RGB(154, 154, 154)
        self.playCountLabel.textColor = RGB(154, 154, 154)
        self.trackCountLabel.textColor = RGB(154, 154, 154)
    }
    
    //MARK: ==================
    func heightForRow() -> CGFloat {
        return 90.0
    }
}
