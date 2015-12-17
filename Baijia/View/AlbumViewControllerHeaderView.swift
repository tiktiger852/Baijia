//
//  AlbumViewControllerHeader.swift
//  Baijia
//
//  Created by mac on 11/18/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumViewControllerHeader: UIView {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var mask2View: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tagButton1: UIButton!
    @IBOutlet weak var tagButton2: UIButton!
    @IBOutlet weak var tagButton3: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var relationButton: UIButton!
    
    
    override func awakeFromNib() {
        self.bgImageView.hidden = true
        self.mask2View.backgroundColor = RGBA(40, 40, 40, 0.7)
        
        self.avatarImageView.layer.cornerRadius = 12.5
        self.avatarImageView.clipsToBounds = true
        
        self.descLabel.textColor = RGB(147, 147, 136)
    }
    
    //MARK:
    var info: AlbumIntro? {
        didSet {
            self.bgImageView.kf_setImageWithURL(NSURL(string: self.info!.coverLarge)!, placeholderImage: nil, optionsInfo: nil) { (image, error, cacheType, imageURL) -> () in
                if let image1 = image {
                    self.bgImageView.image = image1.applyBlurWithRadius(20.0, tintColor: RGBA(0, 0, 0, 0), saturationDeltaFactor: 1.0, maskImage: nil)
                    self.bgImageView.hidden = false
                }
            }
            
            self.thumbImageView.kf_setImageWithURL(NSURL(string: self.info!.coverMiddle)!)
            
            self.avatarImageView.kf_setImageWithURL(NSURL(string: self.info!.avatarPath)!)
            
            self.usernameLabel.text = self.info!.nickname
            self.descLabel.text = self.info!.intro
            
            /*
            let tags = (self.info!.tags as NSString).componentsSeparatedByString(",")
            
            for (key, value) in tags.enumerate() {
                if key > 2 {
                    break
                }
                let tagButton = self.viewWithTag(key+100) as! UIButton
                tagButton.setTitle(value, forState: .Normal)
                tagButton.setTitleColor(RGB(147, 148, 140), forState: .Normal)
                tagButton.clipsToBounds = true
                tagButton.setBackgroundImage(UIImage.fromColor(RGB(210, 210, 210), size: CGSizeMake(1, 1)), forState: .Highlighted)
                
                tagButton.layer.cornerRadius = 13.0
                tagButton.layer.borderWidth = 1.0
                tagButton.layer.borderColor = RGB(147, 148, 140).CGColor
                tagButton.hidden = false
            }
            */
        }
    }
}