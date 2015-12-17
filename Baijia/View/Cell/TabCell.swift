//
//  TabCell.swift
//  Baijia
//
//  Created by mac on 11/14/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class TabCell: UITableViewCell {
    
    @IBOutlet weak var tabLabel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!

    override func awakeFromNib() {
        self.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)
        self.selectedBackgroundView = nil
        self.selectionStyle = .None
        
        self.tabLabel.textColor = RGB(51, 51, 51)
        self.moreLabel.textColor = RGB(153, 153, 153)
    }
    
    //MARK: ==============
    var info: [String: AnyObject]? {
        didSet {
            self.tabLabel.text = self.info!["title"] as? String
            self.moreLabel.text = "更多"
        }
    }
    
    //MARK: ==================
    func heightForRow() -> CGFloat {
        return 44.0
    }
}