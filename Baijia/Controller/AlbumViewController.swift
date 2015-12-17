//
//  AlbumViewController.swift
//  Baijia
//
//  Created by mac on 11/14/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class AlbumViewController: MyViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    //MARK: - Properties
    private var albumId: Int!
    private var pageId = 1
    private var pageSize: Int?
    private var maxPageId: Int?
    
    private var loadMoreDataIndicator: UIActivityIndicatorView!
    private var loadMoreDataLabel: UILabel!
    private var hasmore = false
    private var loading = false
    private var isRefresh = true
    
    private var albumIntro: AlbumIntro?
    private var list = [[Any]]()
    
    private var toolbarView: UIView = {
        let toolbarView = UIView(frame: CGRectMake(0, 240, SCREEN_WIDTH, 40))
        toolbarView.backgroundColor = RGB(244, 244, 244)

        return toolbarView
    }()
    
    private var navBarBgImageView: UIImageView = {
        let navBarBgImageView = UIImageView(frame: CGRectMake(0, -80, SCREEN_WIDTH, 320))
        return navBarBgImageView
    }()
    
    private lazy var navItem: UINavigationItem = {
        [unowned self] in
        
        let button = UIButton(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 0, 24, 24)
        button.setImage(UIImage(named: "nav_ico_back_white")!, forState: .Normal)
        button.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        return navItem
    }()
    private lazy var navBar: UINavigationBar = {
        [unowned self] in
        
        let navBarBgView = UIView(frame: CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT))
        navBarBgView.backgroundColor = UIColor.clearColor()
        navBarBgView.clipsToBounds = true
        navBarBgView.addSubview(self.navBarBgImageView)
        
        let navBarBgMaskView = UIView(frame: navBarBgView.bounds)
        navBarBgMaskView.backgroundColor = RGBA(40, 40, 40, 0.5)
        navBarBgMaskView.hidden = true
        navBarBgView.addSubview(navBarBgMaskView)
        
        let navBar = UINavigationBar(frame: CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT))
        navBar.pushNavigationItem(self.navItem, animated: true)
        navBar.subviews[0].hidden = true
        navBar.insertSubview(navBarBgView, atIndex: 0)
        return navBar
    }()
    
    private lazy var tableView: UITableView = {
        [unowned self] in
        let tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "AlbumIntroCell", bundle: nil), forCellReuseIdentifier: "AlbumIntroCell")
        tableView.registerNib(UINib(nibName: "ListCell2", bundle: nil), forCellReuseIdentifier: "ListCell2")
        tableView.contentInset = UIEdgeInsetsMake(-80, 0, 0, 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        
        return tableView
        }()
    
    init(albumId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.albumId = albumId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.navBar)
        
        self.view.insertSubview(self.tableView, belowSubview: self.navBar)
        
        self.requestData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        if let playerViewController = (UIApplication.sharedApplication().delegate as! AppDelegate).playerViewController {
            let playingAnimImageView = UIImageView(frame: CGRectMake(0, 0, 24, 24))
            playingAnimImageView.userInteractionEnabled = true
            playingAnimImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "gotoPlayerViewController"))
            
            let playingItemButton = UIBarButtonItem(customView: playingAnimImageView)
            self.navItem.rightBarButtonItem = playingItemButton
            
            switch(playerViewController.streamer!.status) {
            case .Playing:
                playingAnimImageView.animationImages = [
                    image("cm2_topbar_icn_playing")!,
                    image("cm2_topbar_icn_playing2")!,
                    image("cm2_topbar_icn_playing3")!,
                    image("cm2_topbar_icn_playing4")!,
                    image("cm2_topbar_icn_playing5")!,
                    image("cm2_topbar_icn_playing6")!,
                    image("cm2_topbar_icn_playing5")!,
                    image("cm2_topbar_icn_playing4")!,
                    image("cm2_topbar_icn_playing3")!,
                    image("cm2_topbar_icn_playing2")!,
                ]
                playingAnimImageView.animationDuration = 1.0
                playingAnimImageView.animationRepeatCount = 0
                playingAnimImageView.startAnimating()
            case .Buffering, .Error, .Finished, .Idle, .Paused:
                playingAnimImageView.image = image("cm2_topbar_icn_playing")!
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    //MARK:
    func requestData() {
        Util.showTipHUD("加载中...", view: self.tableView)
        self.loadData { (data) -> Void in
            Util.hideHUD(self.tableView)
            if data != nil {
                self.albumIntro = data!.0
                self.list = data!.1
                
                self.pageSize = (data!.2 )["pageSize"]
                self.maxPageId = (data!.2 )["maxPageId"]
                
                self.tableView.tableHeaderView = self.viewForTableViewHeader()
                self.tableView.tableFooterView = self.viewForTableViewFooter()
                
                self.updateNavBarBg()
                self.view.addSubview(self.toolbarView)
                
                if self.pageId == self.maxPageId {
                    self.loadMoreDataLabel.text = LOAD_COMPLETE_TEXT
                }else if self.pageId < self.maxPageId {
                    self.hasmore = true
                    self.pageId++
                }
            
                self.tableView.separatorStyle = .SingleLine
                
                self.tableView.reloadData()
            }
        }
    }
    
    func loadMoreData() {
        if !self.hasmore {
            return
        }
        self.loading = true
        
        self.loadMoreDataLabel.hidden = true
        self.loadMoreDataIndicator.startAnimating()
        self.loadData { (data) -> Void in
            self.loadMoreDataIndicator.stopAnimating()
            self.loading = false
            if data != nil {
                self.list += data!.1
                if self.pageId == self.maxPageId {
                    self.loadMoreDataLabel.text = LOAD_COMPLETE_TEXT
                    self.hasmore = false
                }else if self.pageId < self.maxPageId {
                    self.pageId++
                }
            }
            
            self.loadMoreDataLabel.hidden = false
            self.tableView.reloadData()
        }
    }
    
    func loadData(callback: (AlbumIntro, [[Any]], [String: Int])? -> Void) {
        HttpRequest.sharedInstance.getAlbumInfo(albumId: self.albumId, pageId: self.pageId) { (data) -> Void in
            callback(data)
        }
    }
    
    func viewForTableViewHeader() -> UIView {
        
        let nibView = NSBundle.mainBundle().loadNibNamed("AlbumViewControllerHeaderView", owner: self, options: nil)
        
        let albumViewControllerHeaderView = nibView[0] as! AlbumViewControllerHeaderView
        albumViewControllerHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 320)
        albumViewControllerHeaderView.info = self.albumIntro!
        
        return albumViewControllerHeaderView
    }
    
    func viewForTableViewFooter() -> UIView {
        let footerView = UIView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 60))
        
        let borderTop = CALayer()
        borderTop.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5)
        borderTop.backgroundColor = RGB(232, 232, 232).CGColor
        footerView.layer.addSublayer(borderTop)
        
        self.loadMoreDataIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.loadMoreDataIndicator.center = footerView.center
        footerView.addSubview(self.loadMoreDataIndicator)
        
        self.loadMoreDataLabel = UILabel(frame: CGRectMake(0, 0, 80, 14))
        self.loadMoreDataLabel.center = footerView.center
        self.loadMoreDataLabel.textColor = RGB(154, 154, 154)
        self.loadMoreDataLabel.font = UIFont.systemFontOfSize(14.0)
        self.loadMoreDataLabel.textAlignment = .Center
        self.loadMoreDataLabel.text = LOAD_MORE_TEXT
        footerView.addSubview(self.loadMoreDataLabel)
        
        return footerView
    }
    
    func updateNavBarBg() {
        let urlString = self.albumIntro!.coverLarge
        
        self.navBarBgImageView.hidden = true
        self.navBarBgImageView.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: nil, optionsInfo: nil) { (image, error, cacheType, imageURL) -> () in
            if let image1 = image {
                self.navBarBgImageView.image = image1.applyBlurWithRadius(20.0, tintColor: RGBA(0, 0, 0, 0), saturationDeltaFactor: 1.0, maskImage: nil)
                
                self.navBarBgImageView.hidden = false
                self.navBarBgImageView.superview?.subviews[1].hidden = false
            }
        }
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func gotoPlayerViewController() {
        let playerViewController = (UIApplication.sharedApplication().delegate as! AppDelegate).playerViewController!
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell2", forIndexPath: indexPath) as! ListCell2
        
        let info = self.list[indexPath.section][indexPath.row] as! Track
        cell.info = info
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.list.count
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 40))
        view.backgroundColor = RGB(244, 244, 244)
        return view
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40.0
        }
        return 0.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let trackId = (self.list[indexPath.section][indexPath.row] as! Track).trackId!
        let playViewController = PlayerViewController(trackId: trackId, playIndex: indexPath.row)
        self.navigationController?.pushViewController(playViewController, animated: true)
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset.y = 0
        }
        
        if scrollView.contentOffset.y >= 256 {
            self.navBarBgImageView.y = -256
        }else {
            self.navBarBgImageView.y = -scrollView.contentOffset.y
        }
        
        if scrollView.contentOffset.y >= 256 {
            self.toolbarView.y = 64
        }else {
            self.toolbarView.y = 80 - scrollView.contentOffset.y + 240
        }
        
        if self.hasmore && !self.loading && (scrollView.contentSize.height - scrollView.contentOffset.y) < (CGRectGetHeight(scrollView.frame) - 40) {
            self.loadMoreData()
        }
    }
}
