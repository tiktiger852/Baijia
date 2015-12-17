//
//  ListCell2.swift
//  Baijia
//
//  Created by mac on 11/16/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class ListCell2: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishTimeLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    override func awakeFromNib() {
        self.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0)
        
        self.thumbImageView.layer.cornerRadius = 28
        self.thumbImageView.clipsToBounds = true
        self.playImageView.layer.borderColor = RGB(255, 255, 255).CGColor
        self.playImageView.layer.borderWidth = 1.0
        self.playImageView.layer.cornerRadius = 9.0
        
        self.titleLabel.textColor = RGB(51, 51, 51)
        self.publishTimeLabel.textColor = RGB(153, 153, 153)
        self.authorLabel.textColor = RGB(153, 153, 153)
        self.playCountLabel.textColor = RGB(153, 153, 153)
        self.likeCountLabel.textColor = RGB(153, 153, 153)
        self.commentCountLabel.textColor = RGB(153, 153, 153)
        self.durationLabel.textColor = RGB(153, 153, 153)
        
    }
    
    //MARK:
    var info: Track? {
        didSet {
            self.thumbImageView.kf_setImageWithURL(NSURL(string: self.info!.coverSmall!)!)
            self.titleLabel.text = self.info!.title
            self.publishTimeLabel.text = self.info!.createdAt!.formatTime
            self.authorLabel.text = "by \(self.info!.nickname!)"
            self.playCountLabel.text = self.info!.playtimes!.format
            self.likeCountLabel.text = self.info!.likes!.format
            self.commentCountLabel.text = self.info!.comments!.format
            self.durationLabel.text = self.info!.duration!.formatTime2
        }
    }
}
