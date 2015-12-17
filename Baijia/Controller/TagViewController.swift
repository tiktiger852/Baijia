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

class TableViewController: UITableViewController {
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "Cell")
        if !self.hasFilter {
            self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
        }else {
            title = "全部"
        }
        self.tableView.separatorStyle = .None
        self.tableView.showsVerticalScrollIndicator = false

        self.addRefreshControl()
        
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
            self.tableView.contentOffset = CGPointMake(0, -44)
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
    
    //MARK:
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ListCell
        
        let album = self.albums[indexPath.row]
        cell.info = album
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let albumViewController = AlbumViewController(albumId: self.albums[indexPath.row].albumId)
        self.navigationController?.pushViewController(albumViewController, animated: true)
        
        if ((self.navigationController?.respondsToSelector("interactivePopGestureRecognizer")) != nil) {
        ///    self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
    }
    
    //MARK: UIScrollViewDelegate
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.hasmore && !self.loading && (scrollView.contentSize.height - scrollView.contentOffset.y) < (CGRectGetHeight(scrollView.frame) - 40) {
            self.loadMoreData()
        }
    }
    
    //MARK:
    override var edgesForExtendedLayout: UIRectEdge {
        get { return .None}
        set {}
    }
    
    var pageId: Int = 1
    var maxPageId: Int!
    
    var albums = [Album]()
    var dicts = [String: [Album]]()
    
    var refreshControl2: ODRefreshControl?
    
    var loadMoreDataIndicator: UIActivityIndicatorView!
    var loadMoreDataLabel: UILabel!
    var hasmore = false
    var loading = false
    
    var isRefresh = true
    
    var tagName: String!
    
    var title2: String!
    var hasFilter = false
    var calcDimension = "hot"
    var items = ["hot": "最热", "recent": "最近更新", "mostplay": "经典"]
    
    init(tagName: String) {
        super.init(style: .Plain)
        self.tagName = tagName
    }
    
    convenience init(tagName: String, title2: String, hasFilter: Bool) {
        self.init(tagName: tagName)
        self.title2 = title2
        self.hasFilter = hasFilter
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
}
