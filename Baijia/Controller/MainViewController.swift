//
//  RootViewController.swift
//  Baijia
//
//  Created by mac on 11/11/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import HMSegmentedControl

class MainViewController: MyViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    private var titles = ["推荐", "名师经典", "历史传奇", "风云人物", "帝王将相", "国学经典"]
    
    lazy var navItem: UINavigationItem = {
        let navItem = UINavigationItem(title: "百家讲坛")
        return navItem
    }()
    private lazy var navBar: UINavigationBar = {
        [unowned self] in
        let navBar = UINavigationBar(frame: CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT))
        navBar.pushNavigationItem(self.navItem, animated: true)
    
        return navBar
    }()
    
    private lazy var segmentedControl: HMSegmentedControl = {
        [unowned self] in
        let segmentedControl = HMSegmentedControl(frame: CGRectMake(0, NAVBAR_HEIGHT+0.5, SCREEN_WIDTH, 40))
        segmentedControl.backgroundColor = UIColor.clearColor()
        
        let botBorderLayer = CALayer()
        botBorderLayer.frame = CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)
        botBorderLayer.backgroundColor = RGBA(0, 0, 0, 0.3).CGColor
        segmentedControl.layer.insertSublayer(botBorderLayer, atIndex: 0)
        
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = segmentedControl.bounds
        segmentedControl.insertSubview(effectView, atIndex: 0)
        
        segmentedControl.sectionTitles = self.titles
        segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic
        segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15)
        segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 30)
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.selectionIndicatorHeight = 2.0
        segmentedControl.selectionIndicatorColor = RGB(248, 100, 66)
        segmentedControl.titleTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(15.0), NSForegroundColorAttributeName: RGB(102, 102, 102)]
        segmentedControl.selectedTitleTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(16.0), NSForegroundColorAttributeName: RGB(248, 100, 66)]
        segmentedControl.indexChangeBlock = {index -> Void in
            self.contentView.setContentOffset(CGPointMake(SCREEN_WIDTH*CGFloat(index), 0), animated: false)
            self.updateUI(index)
        }
        return segmentedControl
    }()
    
    lazy var contentView: UIScrollView = {
        [unowned self] in
        let contentView = UIScrollView(frame: CGRectMake(0, self.segmentedControl.y, SCREEN_WIDTH, SCREEN_HEIGHT - self.segmentedControl.y))
        contentView.delegate = self
        contentView.pagingEnabled = true
        contentView.showsHorizontalScrollIndicator = false
        contentView.showsVerticalScrollIndicator = false
        contentView.bounces = false
        contentView.contentSize = CGSizeMake(CGFloat(self.titles.count)*SCREEN_WIDTH, contentView.height)
        
        return contentView
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.navBar)
        self.view.insertSubview(self.segmentedControl, belowSubview: self.navBar)
        self.view.insertSubview(self.contentView, belowSubview: self.segmentedControl)
        self.addController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftButton = UIButton(type: .Custom)
        leftButton.frame = CGRectMake(0, 0, 20, 20)
        leftButton.setImage(UIImage(named: "iconfont-yonghu")!, forState: .Normal)
        leftButton.addTarget(self, action: "leftButtonClicked", forControlEvents: .TouchUpInside)
        
        self.navItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        var items = [UIBarButtonItem]()
        if let playerViewController = (UIApplication.sharedApplication().delegate as! AppDelegate).playerViewController {
            let playingAnimImageView = UIImageView(frame: CGRectMake(0, 0, 24, 24))
            playingAnimImageView.userInteractionEnabled = true
            playingAnimImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "gotoPlayerViewController"))
            
            let playingItemButton = UIBarButtonItem(customView: playingAnimImageView)
            items.append(playingItemButton)
            
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
        /*
        let searchButton = UIButton(type: .Custom)
        searchButton.frame = CGRectMake(0, 0, 24, 24)
        searchButton.setImage(UIImage(named: "iconfont-sousuo")!, forState: .Normal)
        searchButton.addTarget(self, action: "searchButtonClicked", forControlEvents: .TouchUpInside)
        items.append(UIBarButtonItem(customView: searchButton))
        */
        self.navItem.rightBarButtonItems = items
    }
    
    //MARK:
    func addController() {
        for (key, value) in self.titles.enumerate() {
            if key == 0 {
                let recommendViewController = RecommendViewController()
                self.addChildViewController(recommendViewController)
                continue
            }
            let tagViewController = TagViewController(tagName: value)
            self.addChildViewController(tagViewController)
        }
        
        if let viewController = self.childViewControllers.first {
            viewController.view.frame = self.contentView.bounds
            self.contentView.addSubview(viewController.view)
        }
    }
    
    func updateUI(index: Int) {
        let viewController = self.childViewControllers[index]
        if viewController.view.superview == nil {
            viewController.view.frame = self.contentView.bounds
            viewController.view.x = SCREEN_WIDTH * CGFloat(index)
            self.contentView.addSubview(viewController.view)
        }
    }
    
    func gotoPlayerViewController() {
        let playerViewController = (UIApplication.sharedApplication().delegate as! AppDelegate).playerViewController!
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
    
    func leftButtonClicked() {
        if let parentViewController = self.parentViewController as? RootViewController {
            parentViewController.showLeftViewController()
        }
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = Int(floor(scrollView.contentOffset.x/SCREEN_WIDTH))
        self.segmentedControl.setSelectedSegmentIndex(UInt(index), animated: true)
        self.updateUI(index)
    }
    
    
}
