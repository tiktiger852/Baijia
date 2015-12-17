//
//  AppDelegate.swift
//  Baijia
//
//  Created by mac on 11/10/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var reach: Reachability?
    var playerViewController: PlayerViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.sharedApplication().statusBarHidden = false
        
        self.monitorNetStatus()
        self.customizeUIStyle()
        
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
        self.window                     = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor    = UIColor.whiteColor()

        let rootViewController = RootViewController(leftViewController: LeftViewController(), mainViewController: MainViewController())
        
        self.window!.rootViewController = MyNavigationController(rootViewController: rootViewController)
        self.window!.makeKeyAndVisible()
        
        return true
    }
    
    func customizeUIStyle() {
        UINavigationBar.appearance()
            .titleTextAttributes = [NSForegroundColorAttributeName: RGB(53, 53, 53), NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0)]
    }
    
    func monitorNetStatus() {
        self.reach = Reachability.reachabilityForInternetConnection()
        self.reach!.startNotifier()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        if event?.type == .RemoteControl {
            let subtype = event!.subtype
            switch(subtype) {
                case .RemoteControlTogglePlayPause, .RemoteControlPlay, .RemoteControlPause, .RemoteControlStop:
                    self.playerViewController?.play()
                case .RemoteControlPreviousTrack:
                    self.playerViewController?.prev()
                case .RemoteControlNextTrack:
                    self.playerViewController?.next()
                default:
                    return
            }
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

