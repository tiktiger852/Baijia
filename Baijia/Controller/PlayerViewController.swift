//
//  PlayViewController.swift
//  Baijia
//
//  Created by mac on 11/16/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerViewController: UIViewController {

    //MARK: Private Properties
    private var trackId: Int?
    private var trackInfo: Track?
    private var playlist = [Media]()
    
    private var playerView: PlayerView!

    var streamer: DOUAudioStreamer?
    private var currentIndex = 0
    private var progressUpdateTimer: NSTimer?
    private var bufferProgressUpdateTimer: NSTimer?
    private var progressBarViewWidth: CGFloat?
    private var updateProgressBarSliderViewLeftConstraint = true
    private var progressBarSliderViewCurrentLeftConstrain: CGFloat?
    
    private var angle = 0.0
    private var discRotateTimer: NSTimer?
    
    private var kStatusKVOKey = "kStatusKVOKey"
    private var kDurationKVOKey = "kDurationKVOKey"
    private var kBufferingRatioKVOKey = "kBufferingRatioKVOKey"
    
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
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).playerViewController = self
        
        self.view.addSubview(self.navBar)
        self.loadData()
        
        print("xxx")
    }
    
    override func loadView() {
        let nibView = NSBundle.mainBundle().loadNibNamed("PlayerView", owner: self, options: nil)
        
        self.playerView = nibView[0] as! PlayerView
        self.playerView.frame = UIScreen.mainScreen().bounds
        self.playerView.prevButton.addTarget(self, action: "prev", forControlEvents: .TouchUpInside)
        self.playerView.playButton.addTarget(self, action: "play", forControlEvents: .TouchUpInside)
        self.playerView.nextButton.addTarget(self, action: "next", forControlEvents: .TouchUpInside)
        self.playerView.progressBarView.beginChageValue = ({
            [unowned self] in
            self.progressUpdateTimer?.invalidate()
            self.progressUpdateTimer = nil
        })
        
        self.playerView.progressBarView.valueChanging = ({ [unowned self]
            (progress) -> Void in
            let currentTime = self.streamer!.duration * Double(progress)
            self.playerView.durationLabel.text = Int(currentTime).formatTime2
        })
        
        self.playerView.progressBarView.valueChanged = ({ [unowned self]
            (progress) -> Void in
            let currentTime = self.streamer!.duration * Double(progress)
            self.streamer!.currentTime = currentTime
            if self.progressUpdateTimer == nil {
                self.progressUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
            }
        })
        
        
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
        /*
        self.destroyStreamer()
        if self.progressUpdateTimer != nil {
            self.progressUpdateTimer!.invalidate()
            self.progressUpdateTimer = nil
        }*/
    }
    
    //MARK:
    func loadData() {
        HttpRequest.sharedInstance.getTrackInfo(self.trackId!) { [unowned self]
            (data) -> Void in
            if data != nil {
                self.trackInfo = data!
                self.playerView.trackInfo = data!
                
                HttpRequest.sharedInstance.getPlaylist(data!.albumId!, callback: { [unowned self]
                    (data2) -> Void in
                    if data2 != nil {
                        self.navItem.title = data2!["albumTitle"] as? String
                        let tracks = data2!["playlist"] as! [Track]
                        
                        for track in tracks {
                            let media = Media(title: track.title!, urlString: track.playUrl32!)
                            self.playlist.append(media)
                            
                        }
                        self.updatePlayerView()
                        self.createStreamer()
                    }
                })
            }
        }
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func updatePlayerView() {
        self.playerView.loveButton.enabled = true
        self.playerView.downloadButton.enabled = true
        self.playerView.commentButton.enabled = true
        self.playerView.moreButton.enabled = true
        
        self.playerView.prevButton.enabled = true
        self.playerView.nextButton.enabled = true
    }
    
    //MARK: - DOUAudioStreamer
    func createStreamer() {
        self.destroyStreamer()
        if self.playlist.count > 0 {
            let media = self.playlist[self.currentIndex]
            self.navItem.title = media.title
            
            self.streamer = DOUAudioStreamer(audioFile: media)
            self.streamer!.addObserver(self, forKeyPath: "status", options: .New, context: &kStatusKVOKey)
            self.streamer!.addObserver(self, forKeyPath: "duration", options: .New, context: &kDurationKVOKey)
            self.streamer!.addObserver(self, forKeyPath: "bufferingRatio", options: .New, context: &kBufferingRatioKVOKey)
            
            self.progressUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
            
            self.updateBuffering()
            self.streamer!.play()
            self.playingInfoCenter()
        }
    }
    
    func destroyStreamer() {
        if self.streamer != nil {
            self.streamer!.pause()
            self.streamer!.removeObserver(self, forKeyPath: "status")
            self.streamer!.removeObserver(self, forKeyPath: "duration")
            self.streamer!.removeObserver(self, forKeyPath: "bufferingRatio")
            self.streamer = nil
        }
        
        if self.progressUpdateTimer != nil {
            self.progressUpdateTimer!.invalidate()
            self.progressUpdateTimer = nil
        }
        
        if self.discRotateTimer != nil {
            self.discRotateTimer!.invalidate()
            self.discRotateTimer = nil
        }
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &kStatusKVOKey {
            self.performSelector("updateStatus", onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: false)
        }else if context == &kDurationKVOKey {
            self.performSelector("updateProgress", onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: false)
        }else if context == &kBufferingRatioKVOKey {
            self.performSelector("updateBuffering", onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: false)
        }else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func updateStatus() {
        let status = self.streamer!.status
        print(status.rawValue)
        switch(status) {
            case .Idle:
                self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_play")!, forState: .Normal)
                self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_play_prs")!, forState: .Highlighted)
                self.playerView.progressBarView.stop()
                self.playNeedleRotate(-0.5)
            case .Buffering:
                self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_play")!, forState: .Normal)
                self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_play_prs")!, forState: .Highlighted)
                self.playerView.playButton.enabled = false
                self.playerView.prevButton.enabled = true
                self.playerView.nextButton.enabled = true
                self.playerView.progressBarView.start()
                if self.discRotateTimer != nil {
                    self.discRotateTimer!.invalidate()
                    self.discRotateTimer = nil
                }
                self.playNeedleRotate(-0.5)
            case .Playing:
                self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_pause")!, forState: .Normal)
                self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_pause_prs")!, forState: .Highlighted)
                self.playerView.playButton.enabled = true
                self.playerView.prevButton.enabled = true
                self.playerView.nextButton.enabled = true
                self.playerView.progressBarView.stop()
                
                if self.discRotateTimer == nil {
                    self.discRotateTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "discStartRotate", userInfo: nil, repeats: true)
                }
                self.playNeedleRotate(0)
            case .Paused:
                self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_play")!, forState: .Normal)
                self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_play_prs")!, forState: .Highlighted)
                self.playerView.playButton.enabled = true
                self.playerView.prevButton.enabled = true
                self.playerView.nextButton.enabled = true
                self.playerView.progressBarView.stop()
            
                if self.discRotateTimer != nil {
                    self.discRotateTimer!.invalidate()
                    self.discRotateTimer = nil
                }
                self.playNeedleRotate(-0.5)
            case .Finished:
                self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_play")!, forState: .Normal)
                self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_play_prs")!, forState: .Highlighted)
                self.playerView.playButton.enabled = true
                self.playerView.prevButton.enabled = true
                self.playerView.nextButton.enabled = true
                self.playerView.progressBarView.stop()
                if self.discRotateTimer != nil {
                    self.discRotateTimer!.invalidate()
                    self.discRotateTimer = nil
                }
                self.next()
            case .Error:
                self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_play")!, forState: .Normal)
                self.playerView.playButton.setImage(UIImage(named: "cm2_runfm_btn_play_prs")!, forState: .Highlighted)
                self.playerView.playButton.enabled = false
                self.playerView.prevButton.enabled = true
                self.playerView.nextButton.enabled = true
                self.playerView.progressBarView.stop()
                if self.discRotateTimer != nil {
                    self.discRotateTimer!.invalidate()
                    self.discRotateTimer = nil
                }
                self.playNeedleRotate(-0.5)
        }
    }
    
    func updateBuffering() {
        let buffering = self.streamer!.bufferingRatio
        if buffering > 0.0 {
            self.playerView.progressBarView.buffer = CGFloat(buffering)
        }
    }
    
    func updateProgress() {
        if self.streamer!.duration != 0.0 {
            self.playerView.durationLabel.text = Int(self.streamer!.currentTime).formatTime2
            self.playerView.totalTimeLabel.text = Int(self.streamer!.duration).formatTime2
        
            let progress = self.streamer!.currentTime / self.streamer!.duration
            self.playerView.progressBarView.progress = CGFloat(progress)
        }
    }
    
    func prev() {
        if --self.currentIndex < 0 {
            self.currentIndex = 0
        }else {
            self.createStreamer()
        }
    }
    
    func play() {
        if self.streamer!.status == .Paused || self.streamer!.status == .Idle || self.streamer!.status == .Finished {
            self.streamer!.play()
        }else {
            self.streamer!.pause()
        }
    }
    
    func next() {
        if ++self.currentIndex >= self.playlist.count {
            self.currentIndex = self.playlist.count - 1
        }else {
            self.createStreamer()
        }
    }
    
    func discStartRotate() {
        self.angle += 0.01
        if self.angle > 6.28 {
            self.angle = 0.0
        }
        
        self.playerView.discView.transform = CGAffineTransformMakeRotation(CGFloat(self.angle))
    }
    
    func playNeedleRotate(angle: CGFloat) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.Linear)
        UIView.setAnimationDuration(0.5)
        self.playerView.playNeedleImageView.transform = CGAffineTransformMakeRotation(CGFloat(angle))
        UIView.commitAnimations()
    }
    
    func playingInfoCenter() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let data = NSData(contentsOfURL: url(self.trackInfo!.coverMiddle!)!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if data != nil {
                    let image = UIImage(data: data!)!
                    MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
                        MPMediaItemPropertyTitle: self.playlist[self.currentIndex].title,
                        MPMediaItemPropertyArtist: self.trackInfo!.albumTitle!,
                        MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: image)
                    ]
                }
            })
        }
    }
}
