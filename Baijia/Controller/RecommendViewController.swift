//
//  Recommend.swift
//  Baijia
//
//  Created by mac on 11/13/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import ODRefreshControl

class RecommendViewController: MyViewController, UITableViewDelegate, UITableViewDataSource,
    LZAutoScrollViewDelegate, UIGestureRecognizerDelegate {

    //MARK: Properties
    var banners = [Banner]()
    var list = [[Any]]()
    
    private lazy var tableView: UITableView = {
        [unowned self] in
        
        let tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.registerNib(UINib(nibName: "TabCell", bundle: nil), forCellReuseIdentifier: "TabCell")
        tableView.registerNib(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        //tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
        tableView.separatorStyle = .None

        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableView)
        self.addRefreshControl()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.frame = self.view.bounds
    }
    
    //MARK:
    func addRefreshControl() {
        let refreshControl = ODRefreshControl(inScrollView: self.tableView)
        refreshControl.addTarget(self, action: "refreshData:", forControlEvents: .ValueChanged)
        
        refreshControl.beginRefreshing()
        self.refreshData(refreshControl)
    }
    
    func refreshData(refreshControl: ODRefreshControl) {
        HttpRequest.sharedInstance.getRecommendList { (data) -> Void in
            refreshControl.endRefreshing()
            if data != nil {
                self.banners = data!.0
                self.list = data!.1
            
                self.tableView.tableHeaderView = self.viewForTableViewHeader()
                self.tableView.separatorStyle = .SingleLine
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)
            cell.backgroundColor = RGB(244, 244, 244)
            cell.selectedBackgroundView = nil
            cell.selectionStyle = .None
            return cell
            
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TabCell", forIndexPath: indexPath) as! TabCell
            
            let info = self.list[indexPath.section][indexPath.row] as! [String: AnyObject]
            cell.info = info
            
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath) as! ListCell
        cell.selectedBackgroundView = nil
        cell.selectionStyle = .None
        
        let info = self.list[indexPath.section][indexPath.row] as! Album
        cell.info = info
        
        if indexPath.row == (self.list[indexPath.section].count - 1) {
            cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 10.0
        }else if indexPath.row == 1 {
            return 34.0
        }
        
        return 85.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.list.count
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.row == 1 {
            let info = self.list[indexPath.section][indexPath.row] as! [String: AnyObject]
            let tagViewController = TagViewController(tagName: info["tagName"]! as! String, hasFilter: true)
            self.navigationController?.pushViewController(tagViewController, animated: true)
        }else if indexPath.row > 1 {
            let info = self.list[indexPath.section][indexPath.row] as! Album
            let albumViewController = AlbumViewController(albumId: info.albumId)
            
            self.navigationController?.pushViewController(albumViewController, animated: true)
        }
    }
    
    //MARK:
    func viewForTableViewHeader() -> UIView {
        var images = [String]()
        for banner in self.banners {
            images.append(banner.pic)
        }
        let view = LZAutoScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 150))
        view.delegate = self
        view.images = images
        view.interval = 3.0
        view.pageControlAligment = .Center
        view.reloadData()
        
        return view
    }
    
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.locationInView(self.view).x <= 50 {
            return true
        }
        return false
    }
    
    //MARK: LZAutoScrollViewDelegate
    func loadImageWithURLString(urlString: String!, andImageView imageView: UIImageView!) {
        imageView.kf_setImageWithURL(NSURL(string: urlString)!)
    }
    
    func imageClicked(index: Int) {
        let banner = self.banners[index]
        
        if banner.type == 2 {
            let albumViewController = AlbumViewController(albumId: banner.albumId!)
            self.navigationController?.pushViewController(albumViewController, animated: true)
        }else if banner.type == 3 {
            let playerViewController = PlayerViewController(trackId: banner.trackId!, playIndex: 0)
            self.navigationController?.pushViewController(playerViewController, animated: true)
        }
    }
}
