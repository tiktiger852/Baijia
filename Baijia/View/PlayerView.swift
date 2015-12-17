//
//  PlayerView.swift
//  Baijia
//
//  Created by mac on 11/29/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import Kingfisher

class PlayerView: UIView {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverImageMask: UIView!
    @IBOutlet weak var discBackgroundImageView: UIImageView!
    
    @IBOutlet weak var discView: UIView!
    @IBOutlet weak var discFaceImageView: UIImageView!
    @IBOutlet weak var discImageView: UIImageView!
    @IBOutlet weak var playNeedleImageView: UIImageView!
    
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var progressBarView: LZSlider!
    
    @IBOutlet weak var loopButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playlistButton: UIButton!
    
    
    @IBOutlet weak var discViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var playNeedleImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var playNeedleImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var playNeedleImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var playNeedleImageViewCenterXConstraint: NSLayoutConstraint!

    var trackInfo: Track? {
        didSet {
            
            self.coverImageView.kf_setImageWithURL(NSURL(string: self.trackInfo!.coverLarge!)!, placeholderImage: nil, optionsInfo: nil) { [unowned self]
                (image, error, cacheType, imageURL) -> () in
                if let image1 = image {
                    self.coverImageView.image = image1.applyBlurWithRadius(40.0, tintColor: nil, saturationDeltaFactor: 1.0, maskImage: nil)
                    UIView.animateWithDuration(5.0, animations: { [unowned self]
                        () -> Void in
                        self.coverImageView.alpha = 1.0
                    })
                }
            }
            
            self.discFaceImageView.kf_setImageWithURL(NSURL(string: self.trackInfo!.coverMiddle!)!, placeholderImage: nil)
        }
    }
    
    override func awakeFromNib() {
        self.coverImageView.image = UIImage.fromColor(RGB(255, 255, 255))
        self.coverImageMask.backgroundColor = UIColor(white: 0, alpha: 0.2)
        //self.coverImageMask.alpha = 1.0
        self.discFaceImageView.layer.cornerRadius = 76.5
        self.discFaceImageView.clipsToBounds = true
        self.playNeedleImageView.layer.anchorPoint = CGPointMake(0.16, 0.12)
        self.playNeedleImageView.transform = CGAffineTransformRotate(self.playNeedleImageView.transform, CGFloat(-0.5))
        
        if SCREEN_HEIGHT == 568 {
            self.playNeedleImageView.layer.anchorPoint = CGPointMake(0.28, 0.18)
            self.discBackgroundImageView.image = UIImage(named: "cm2_play_disc_mask-568h")
            self.discViewTopConstraint.constant = 65
            self.playNeedleImageView.image = UIImage(named: "cm2_play_needle_play-568h")
            self.playNeedleImageViewWidthConstraint.constant = 97
            self.playNeedleImageViewHeightConstraint.constant = 153
            self.playNeedleImageViewTopConstraint.constant = -77.36
            self.playNeedleImageViewCenterXConstraint.constant = -6.48
        }
        if SCREEN_HEIGHT == 667 {
            self.discBackgroundImageView.image = UIImage(named: "cm2_play_disc_mask-ip6")
        }
        
        self.loveButton.setImage(UIImage(named: "cm2_play_icn_love_prs")!, forState: .Highlighted)
        self.downloadButton.setImage(UIImage(named: "cm2_play_icn_dld_prs")!, forState: .Highlighted)
        self.commentButton.setImage(UIImage(named: "cm2_play_icn_cmt_num_prs")!, forState: .Highlighted)
        self.moreButton.setImage(UIImage(named: "cm2_play_icn_more_prs")!, forState: .Highlighted)
        
        self.durationLabel.textColor = UIColor(white: 1.0, alpha: 0.8)
        self.totalTimeLabel.textColor = UIColor(white: 1.0, alpha: 0.8)
        
        
        
        self.progressBarView.trackImage = UIImage(named: "cm2_playbar_bg")!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 4, 0, 4), resizingMode: .Stretch)
        self.progressBarView.bufferImage = UIImage(named: "cm2_playbar_ready")!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 4, 0, 4), resizingMode: .Stretch)
        self.progressBarView.dotBackgroundImage = UIImage(named: "cm2_playbar_btn")!
        
        self.progressBarView.progressColor = RGB(248, 100, 66)
        self.progressBarView.progressWidth = 2
        
        self.progressBarView.dotWidth = 26
        self.progressBarView.dotHeight = 26
        self.progressBarView.dotCornerRadius = 13
        
        
        self.progressBarView.beginChageValue = {
            
        }
        
        self.nextButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
        self.loopButton.setImage(UIImage(named: "cm2_icn_loop_prs")!, forState: .Highlighted)
        self.prevButton.setImage(UIImage(named: "cm2_play_btn_prev_prs")!, forState: .Highlighted)
        self.playButton.setImage(UIImage(named: "cm2_runfm_btn_play_prs")!, forState: .Highlighted)
        self.nextButton.setImage(UIImage(named: "cm2_play_btn_prev_prs")!, forState: .Highlighted)
        self.playlistButton.setImage(UIImage(named: "cm2_icn_list_prs")!, forState: .Highlighted)
    }
}
