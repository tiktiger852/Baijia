//
//  MenuViewController.swift
//  Baijia
//
//  Created by mac on 12/10/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class LeftViewController: MyViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pushViewController: ((UIViewController) ->Void)?
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: SCREEN_BOUNDS)
        backgroundImageView.image = UIImage(named: "left_bg")
        if SCREEN_HEIGHT == 568 {
            backgroundImageView.image = UIImage(named: "left_bg-568h")
        }
        backgroundImageView.userInteractionEnabled = true
        return backgroundImageView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView(frame: CGRectMake(75, 100, 70, 70))
        avatarImageView.image = UIImage(named: "iconfont-morentouxiang")
        avatarImageView.layer.cornerRadius = 35.0
        if Login.sharedInstance.isLogin() {
            avatarImageView.layer.borderColor = RGB(243, 243, 243).CGColor
            avatarImageView.layer.borderWidth = 1.5
        }
        avatarImageView.clipsToBounds = true
        avatarImageView.userInteractionEnabled = true
        
        return avatarImageView
    }()
    
    private lazy var tableView: UITableView = {
        [unowned self] in
        let tableView = UITableView(frame: CGRectMake(0, 200, 200, 240))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .None
        
        return tableView
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.avatarImageView)
        self.view.addSubview(self.tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        var sel = Selector("login")
        if Login.sharedInstance.isLogin() {
            sel = Selector("uploadAvatar")
        }
        self.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: sel))
        
        if let avatar = Login.sharedInstance.avatar {
            self.avatarImageView.kf_setImageWithURL(NSURL(string: avatar)!, placeholderImage: UIImage(named: "iconfont-morentouxiang1"))
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    //MARK:
    func login() {
        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.push(loginViewController)
        
    }
    
    func uploadAvatar() {
        
    }
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(15.0)
        cell.accessoryType = .DisclosureIndicator
        cell.backgroundColor = UIColor.clearColor()
        
        let selectedBackgroundView = UIView(frame: cell.contentView.bounds)
        selectedBackgroundView.backgroundColor = RGBA(255, 255, 255, 0.15)
        cell.selectedBackgroundView = selectedBackgroundView
        if indexPath.row == 0 {
            cell.imageView?.image = UIImage(named: "iconfont-shoucang")
            cell.textLabel?.text = "我收藏的"
        }else if indexPath.row == 1 {
            cell.imageView?.image = UIImage(named: "iconfont-xiazai")
            cell.textLabel?.text = "下载管理"
        }else if indexPath.row == 2 {
            cell.imageView?.image = UIImage(named: "iconfont-lishijilu")
            cell.textLabel?.text = "播放历史"
        }else if indexPath.row == 3{
            cell.imageView?.image = UIImage(named: "iconfont-shezhi")
            cell.textLabel?.text = "设置"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    //MARK: - UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if indexPath.row == 1 {
            let downloadViewController = DownloadViewController()
            self.push(downloadViewController)
        }
    }

    //MARK:
    func push(viewController: UIViewController!) {
        
        if let pushViewController = self.pushViewController {
            pushViewController(viewController)
        }
    }
}
