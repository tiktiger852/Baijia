//
//  PlayViewController.swift
//  Baijia
//
//  Created by mac on 11/16/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

    //MARK: Private Properties
    private var trackId: Int?
    private var trackInfo: Track?
    private var playlist: [Track]?
    
    private var playerView: PlayerView!
    
    private var streamer: AudioStreamer?
    private var currentIndex = 0
    private var progressUpdateTimer: NSTimer?
    private var bufferProgressUpdateTimer: NSTimer?
    private var progressBarWidth: CGFloat?
    
    private lazy var navItem: UINavigationItem = {
        [unowned self] in
        
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
        
        let bottomBorderLayer = CALayer()
        bottomBorderLayer.frame = CGRectMake(0, navBar.maxY - 0.5, SCREEN_WIDTH, 0.5)
        bottomBorderLayer.backgroundColor = RGBA(255, 255, 255, 0.4).CGColor
        navBar.layer.addSublayer(bottomBorderLayer)
        
        return navBar
    }()
    
    init(trackId: Int!, playIndex: Int!) {
        self.trackId = trackId
        self.currentIndex = playIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerView.prevButton.addTarget(self, action: "prev", forControlEvents: .TouchUpInside)
        self.playerView.playButton.addTarget(self, action: "play", forControlEvents: .TouchUpInside)
        self.playerView.nextButton.addTarget(self, action: "next", forControlEvents: .TouchUpInside)
        self.playerView.progressBar.layoutIfNeeded()
        self.progressBarWidth = self.playerView.progressBar.width
        
        self.view.addSubview(self.navBar)
        self.loadData()
    }
    
    override func loadView() {
        let nibView = NSBundle.mainBundle().loadNibNamed("PlayerView", owner: self, options: nil)
        
        self.playerView = nibView[0] as! PlayerView
        self.playerView.frame = UIScreen.mainScreen().bounds
        self.view = self.playerView
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .Default
        
    }
    
    deinit {
        print("deinit")
        self.destroyStreamer()
        if self.progressUpdateTimer != nil {
            self.progressUpdateTimer!.invalidate()
            self.progressUpdateTimer = nil
        }
    }
    
    //MARK:
    func loadData() {
        HttpRequest.sharedInstance.getTrackInfo(self.trackId!) { [unowned self]
            (data) -> Void in
            if data != nil {
                self.trackInfo = data!
                self.playerView.trackInfo = data!
                self.title = data!.title
                
                HttpRequest.sharedInstance.getPlaylist(data!.albumId!, callback: { (data2) -> Void in
                    if data2 != nil {
                        self.navItem.title = data2!["albumTitle"] as! String
                        self.playlist = data2!["playlist"] as! [Track]
                    
                        if self.streamer == nil {
                            self.createStreamer()
                        }
                    }
                })
            }
        }
    }
    
    func back() {
        self.destroyStreamer()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: - AudioStreamer
    func createStreamer() {
        self.playerView.playedLabel.text = "00:00"
        self.playerView.durationLabel.text = self.playlist![self.currentIndex].duration!.formatTime2
        
        
        self.destroyStreamer()
        self.streamer = AudioStreamer(URL: self.url())
        self.progressUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateProgress:", userInfo: nil, repeats: true)
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: "playbackStateChanged:", name: ASStatusChangedNotification, object: self.streamer!)
        
        self.streamer!.start()
    }
    
    func destroyStreamer() {
        if self.streamer != nil {
            NSNotificationCenter.defaultCenter()
                .removeObserver(self, name: ASStatusChangedNotification, object: self.streamer!)
            self.progressUpdateTimer!.invalidate()
            self.progressUpdateTimer = nil
            
            self.streamer!.stop()
            self.streamer = nil
        }
    }
    
    func url() -> NSURL! {
        //var urlString = self.playlist![self.currentIndex].playUrl32!
        var urlString = "http://zjdx1.sc.chinaz.com/Files/DownLoad/sound1/201511/6589.mp3"
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        return NSURL(string: urlString)!
    }
    
    func updateProgress(timer: NSTimer) {
        let duration = 2.9586022610483
        self.playerView.playedLabel.text = Int(self.streamer!.progress).formatTime2
        let trailing = self.progressBarWidth! - (CGFloat(self.streamer!.progress) / CGFloat(duration) * self.progressBarWidth!)
        let leading = (CGFloat(self.streamer!.progress) / CGFloat(duration) * self.progressBarWidth!) - CGFloat(13)
        self.playerView.progressConstrain.constant = trailing
        self.playerView.progressButtonConstrain.constant = leading
        
    }
    
    func playbackStateChanged(notification: NSNotification) {
        if self.streamer!.isWaiting() {
            self.playerView.progressBarActivityIndicator.startAnimating()
        }else if self.streamer!.isPlaying() {
            self.playerView.progressBarActivityIndicator.stopAnimating()
            self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_pause")!, forState: .Normal)
            self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_pause_prs")!, forState: .Highlighted)
            self.playerView.prevButton.enabled = true
            self.playerView.playButton.enabled = true
            self.playerView.nextButton.enabled = true
        }else if self.streamer!.isPaused() {
            self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_play")!, forState: .Normal)
            self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_play_prs")!, forState: .Highlighted)
        }else if self.streamer!.isIdle() {
            self.destroyStreamer()
            //self.playerView.progressConstrain.constant = self.progressBarWidth!
        }
    }
    
    func play() {
        if self.streamer!.isPlaying() {
            self.streamer!.pause()
            self.progressUpdateTimer!.invalidate()
            self.progressUpdateTimer = nil
        }else if self.streamer!.isPaused() {
            self.streamer!.start()
            if self.progressUpdateTimer == nil {
                self.progressUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateProgress:", userInfo: nil, repeats: true)
            }
        }
    }
    
    func prev() {
        if self.currentIndex > 0 {
            self.currentIndex--
        }
        
        self.createStreamer()
    }
    
    func next() {
        if self.currentIndex < self.playlist!.count {
            self.currentIndex++
        }
        
        self.createStreamer()
    }
}
