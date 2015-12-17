//
//  TableViewController.swift
//  Baijia
//
//  Created by mac on 11/11/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import ODRefreshControl
import Kingfisher

class TagViewController: MyViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    private var pageId: Int = 1
    private var maxPageId: Int!
    
    private var albums = [Album]()
    private var dicts = [String: [Album]]()
    
    private var refreshControl2: ODRefreshControl?
    
    private var loadMoreDataIndicator: UIActivityIndicatorView!
    private var loadMoreDataLabel: UILabel!
    private var hasmore = false
    private var loading = false
    private var isRefresh = true
    
    private var tagName: String!
    private var hasFilter = false
    private var calcDimension = "hot"
    private var items = ["hot": "最热", "recent": "最近更新", "mostplay": "经典"]
    
    private lazy var navItem: UINavigationItem = {
        [unowned self] in
        
        let button = UIButton(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 0, 24, 24)
        button.setImage(UIImage(named: "nav_ico_back")!, forState: .Normal)
        button.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        navItem.title = "全部"
        
        return navItem
    }()
    private lazy var navBar: UINavigationBar = {
        [unowned self] in
        
        let navBar = UINavigationBar(frame: CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT))
        navBar.pushNavigationItem(self.navItem, animated: true)
        
        return navBar
    }()
    
    private lazy var tableView: UITableView = {
        [unowned self] in
        let tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .None
        tableView.rowHeight = 85
        //tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
        if self.hasFilter {
            tableView.contentInset = UIEdgeInsetsMake(NAVBAR_HEIGHT + 0.5, 0, 0, 0)
        }
        return tableView
    }()
    
    init(tagName: String) {
        super.init(nibName: nil, bundle: nil)
        self.tagName = tagName
    }
    
    convenience init(tagName: String, hasFilter: Bool) {
        self.init(tagName: tagName)
        self.hasFilter = hasFilter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.hasFilter {
            self.view.addSubview(self.navBar)
            self.view.insertSubview(self.tableView, belowSubview: self.navBar)
        }else {
            self.view.addSubview(self.tableView)
        }
        self.addRefreshControl()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.frame = self.view.bounds
        
        if let playerViewController = (UIApplication.sharedApplication().delegate as! AppDelegate).playerViewController {
            let playingAnimImageView = UIImageView(frame: CGRectMake(0, 0, 24, 24))
            playingAnimImageView.userInteractionEnabled = true
            playingAnimImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "gotoPlayerViewController"))
            
            let playingItemButton = UIBarButtonItem(customView: playingAnimImageView)
            self.navItem.rightBarButtonItem = playingItemButton
            
            switch(playerViewController.streamer!.status) {
            case .Playing:
                playingAnimImageView.animationImages = [
                    image("cm2_topbar_icn_playing_prs")!,
                    image("cm2_topbar_icn_playing2_prs")!,
                    image("cm2_topbar_icn_playing3_prs")!,
                    image("cm2_topbar_icn_playing4_prs")!,
                    image("cm2_topbar_icn_playing5_prs")!,
                    image("cm2_topbar_icn_playing6_prs")!,
                    image("cm2_topbar_icn_playing5_prs")!,
                    image("cm2_topbar_icn_playing4_prs")!,
                    image("cm2_topbar_icn_playing3_prs")!,
                    image("cm2_topbar_icn_playing2_prs")!,
                ]
                playingAnimImageView.animationDuration = 1.0
                playingAnimImageView.animationRepeatCount = 0
                playingAnimImageView.startAnimating()
            case .Buffering, .Error, .Finished, .Idle, .Paused:
                playingAnimImageView.image = image("cm2_topbar_icn_playing_prs")!
            }
        }
    }
    
    //MARK:
    func addRefreshControl() {
        self.refreshControl2 = ODRefreshControl(inScrollView: self.tableView)
        self.refreshControl2!.addTarget(self, action: "refreshData", forControlEvents: .ValueChanged)
        self.refreshControl2!.beginRefreshing()
        self.refreshData()
    }
    
    func refreshData() {
        self.pageId = 1
        
        self.loadData { (data) -> Void in
            self.refreshControl2!.endRefreshing()
            if data != nil {
                self.maxPageId = data!["maxPageId"] as! Int
            
                let albums = data!["list"] as! [Album]
                if self.hasFilter {
                    self.dicts[self.calcDimension] = albums
                    if self.tableView.tableHeaderView == nil {
                        self.tableView.tableHeaderView = self.viewForTableViewHeader()
                    }
                }
                self.albums = albums
            
                if self.tableView.tableFooterView == nil {
                    self.tableView.tableFooterView = self.tableViewFooterView()
                }
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
                let albums = data!["list"] as! [Album]
                if self.hasFilter {
                    self.dicts[self.calcDimension] = self.dicts[self.calcDimension]! + albums
                    self.albums = self.dicts[self.calcDimension]!
                }else {
                    self.albums += albums
                }
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
    
    func filterData(segmented: UISegmentedControl) {
        let index = segmented.selectedSegmentIndex
        let items = Array(self.items.keys).reverse() as [String]

        self.calcDimension = items[index]
        
        if let albums = self.dicts[self.calcDimension] {
            self.albums = albums
            self.tableView.reloadData()
        }else {
            self.tableView.contentOffset = CGPointMake(0, -108.5)
            self.refreshControl2!.beginRefreshing()
            self.refreshData()
        }
    }
    
    func loadData(callback: [String: Any]? -> Void) {
        HttpRequest.sharedInstance.getTag(tagName: self.tagName, calcDimension: self.calcDimension, pageId: self.pageId) { (data) -> Void in
            callback(data)
        }
    }
    
    func viewForTableViewHeader() -> UIView {
        let headerView = UIView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 48))
        headerView.backgroundColor = RGB(247, 247, 247)
        
        let items = Array(self.items.values).reverse() as [String]
        
        let segmented = UISegmentedControl(items: items)
        segmented.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.9, 28)
        segmented.center = headerView.center
        segmented.tintColor = RGB(248, 100, 66)
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: "filterData:", forControlEvents: .ValueChanged)
        headerView.addSubview(segmented)
        
        return headerView
    }
    
    func tableViewFooterView() -> UIView {
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
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func gotoPlayerViewController() {
        let playerViewController = (UIApplication.sharedApplication().delegate as! AppDelegate).playerViewController!
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ListCell
        
        let album = self.albums[indexPath.row]
        cell.info = album
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let albumViewController = AlbumViewController(albumId: self.albums[indexPath.row].albumId)
        self.navigationController?.pushViewController(albumViewController, animated: true)
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.hasmore && !self.loading && (scrollView.contentSize.height - scrollView.contentOffset.y) < (CGRectGetHeight(scrollView.frame) - 40) {
            self.loadMoreData()
        }
    }
}
