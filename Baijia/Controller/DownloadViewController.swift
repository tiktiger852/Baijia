//
//  DownloadViewController.swift
//  Baijia
//
//  Created by mac on 12/10/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class DownloadViewController: MyViewController {

    lazy var navItem: UINavigationItem = {
        
        let button = UIButton(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 0, 24, 24)
        button.setImage(UIImage(named: "nav_ico_back")!, forState: .Normal)
        button.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        
        let navItem = UINavigationItem(title: "下载管理")
        navItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return navItem
    }()
    private lazy var navBar: UINavigationBar = {
        [unowned self] in
        let navBar = UINavigationBar(frame: CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT))
        navBar.pushNavigationItem(self.navItem, animated: true)
        
        return navBar
        }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.purpleColor()
        self.view.addSubview(self.navBar)
    }
    
    //MARK:
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
