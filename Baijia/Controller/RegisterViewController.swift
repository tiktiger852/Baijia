//
//  RegisterViewController.swift
//  Baijia
//
//  Created by mac on 12/11/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class RegisterViewController: MyViewController {
    
    private lazy var navItem: UINavigationItem = {
        
        let backButton = UIButton(type: .Custom)
        backButton.frame = CGRectMake(0, 0, 24, 24)
        backButton.setImage(UIImage(named: "nav_ico_back_white")!, forState: .Normal)
        backButton.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        return navItem
    }()
    
    private lazy var navBar: UINavigationBar = {
        [unowned self] in
        
        let navBar = UINavigationBar(frame: CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT))
        navBar.subviews.first?.hidden = true
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: RGB(255, 255, 255)]
        navBar.pushNavigationItem(self.navItem, animated: false)
        
        return navBar
        }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
