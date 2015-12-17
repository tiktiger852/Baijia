//
//  MainViewController.swift
//  Baijia
//
//  Created by mac on 12/10/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class RootViewController: MyViewController {
    
    var startPoint: CGPoint?
    var originPoint: CGPoint?
    var scale: CGFloat = 0.77
    var distance: CGFloat = 0.65
    
    let leftViewController: LeftViewController?
    let mainViewController: MainViewController!

    init(leftViewController: LeftViewController?, mainViewController: MainViewController!) {
        self.leftViewController = leftViewController
        self.mainViewController = mainViewController
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.showMainController()
        
        if let leftViewController = self.leftViewController {
            leftViewController.pushViewController = ({ [unowned self]
                (viewController) -> Void in
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.mainViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    self.mainViewController.view.center = self.view.center
                    self.mainViewController.navItem.leftBarButtonItem?.customView?.alpha = 1.0
                    }, completion: { (finished) -> Void in
                        leftViewController.view.removeFromSuperview()
                        leftViewController.removeFromParentViewController()
                        self.mainViewController.childViewControllers.first?.view.userInteractionEnabled = true
                        self.mainViewController.contentView.scrollEnabled = true
                        for gesture in self.mainViewController.view.gestureRecognizers! {
                            if gesture is UITapGestureRecognizer {
                                self.mainViewController.view.removeGestureRecognizer(gesture)
                            }
                        }
                        self.mainViewController.navigationController?.pushViewController(viewController, animated: true)
                })
            })
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:
    func showLeftViewController() {
        guard self.leftViewController != nil else {
            return
        }
        
        if self.childViewControllers.contains(self.leftViewController!) {
            self.leftViewController!.view.removeFromSuperview()
            self.leftViewController!.removeFromParentViewController()
        }
        
        self.addChildViewController(self.leftViewController!)
        
        self.view.insertSubview(self.leftViewController!.view, atIndex: 0)
        
        UIView.animateWithDuration(0.3, animations: { [unowned self]
            () -> Void in
            self.mainViewController.view.transform = CGAffineTransformMakeScale(self.scale, self.scale)
            self.mainViewController.view.center = CGPointMake(self.distance * SCREEN_WIDTH + SCREEN_WIDTH_2, self.view.center.y)
            self.mainViewController.navItem.leftBarButtonItem?.customView?.alpha = 0.0
            }) { (finished) -> Void in
                self.mainViewController.childViewControllers.first?.view.userInteractionEnabled = false
                self.mainViewController.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "restore"))
                self.mainViewController.contentView.scrollEnabled = false
        }
    }
    
    private func showMainController() {
        self.addChildViewController(self.mainViewController)
        self.view.addSubview(self.mainViewController!.view)
        if let recommendViewController = self.mainViewController.childViewControllers.first as? RecommendViewController {
            let recognizer = UIPanGestureRecognizer(target: self, action: "transition:")
            recognizer.delegate = recommendViewController
            recommendViewController.view.addGestureRecognizer(recognizer)
        }
    }
    
    //MARK:
    func transition(pan: UIPanGestureRecognizer) {
        guard self.leftViewController != nil else {
            return
        }
        
        switch(pan.state) {
            case .Began:
                self.startPoint = pan.locationInView(self.view)
                print(self.startPoint?.x)
                if self.startPoint?.x > 50 {
                    return
                }
                
                if self.childViewControllers.contains(self.leftViewController!) {
                    self.leftViewController!.view.removeFromSuperview()
                    self.leftViewController!.removeFromParentViewController()
                }
                
                self.addChildViewController(self.leftViewController!)
                
                self.view.insertSubview(self.leftViewController!.view, atIndex: 0)
            case .Changed:
                if self.startPoint?.x > 50 {
                    return
                }
                let x = pan.translationInView(self.view).x
                
                if x > 0 && (x / SCREEN_WIDTH) <= self.distance {
                    self.mainViewController.view.center = CGPointMake(x + SCREEN_WIDTH_2, self.view.center.y)
                    let scale = 1.0 - (1.0 - self.scale) * (x / (SCREEN_WIDTH * self.distance));
                    self.mainViewController.view.transform = CGAffineTransformMakeScale(scale, scale)
                    
                    let alpha = 1.0 - x / (SCREEN_WIDTH * self.distance)
                    self.mainViewController.navItem.leftBarButtonItem?.customView?.alpha = alpha
                }
            case .Ended, .Cancelled, .Failed, .Possible:
                self.startPoint = nil
                let x = pan.translationInView(self.view).x
                if x >= (SCREEN_WIDTH * self.distance) {
                    self.mainViewController.navItem.leftBarButtonItem?.customView?.alpha = 0.0
                    self.mainViewController.childViewControllers.first?.view.userInteractionEnabled = false
                    self.mainViewController.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "restore"))
                    self.mainViewController.contentView.scrollEnabled = false
                    return
                }
                var x2 = (SCREEN_WIDTH_2 + SCREEN_WIDTH * self.distance)
                var s2 = self.scale
                if x < ((SCREEN_WIDTH_2 + SCREEN_WIDTH * self.distance) * 0.3) {
                    x2 = self.view.center.x
                    s2 = 1.0
                }
                
                UIView.animateWithDuration(0.1, animations: { [unowned self]
                    () -> Void in
                    self.mainViewController.view.center = CGPointMake(x2, self.view.center.y)
                    self.mainViewController.view.transform = CGAffineTransformMakeScale(s2, s2)
                    }, completion: { (finished) -> Void in
                        if s2 == 1.0 {
                            self.leftViewController!.view.removeFromSuperview()
                            self.leftViewController!.removeFromParentViewController()
                            self.mainViewController.navItem.leftBarButtonItem?.customView?.alpha = 1.0
                            self.mainViewController.childViewControllers.first?.view.userInteractionEnabled = true
                            self.mainViewController.contentView.scrollEnabled = true
                            if let gestures = self.mainViewController.view.gestureRecognizers {
                                for gesture in gestures {
                                    if gesture is UITapGestureRecognizer {
                                        self.mainViewController.view.removeGestureRecognizer(gesture)
                                    }
                                }
                            }
                        }else {
                            self.mainViewController.navItem.leftBarButtonItem?.customView?.alpha = 0.0
                            self.mainViewController.childViewControllers.first?.view.userInteractionEnabled = false
                            self.mainViewController.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "restore"))
                            self.mainViewController.contentView.scrollEnabled = false
                        }
                })
            
        }
        self.startPoint = nil
    }
    
    func restore() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.mainViewController.navItem.leftBarButtonItem?.customView?.alpha = 1.0
            self.mainViewController.view.center = self.view.center
            self.mainViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }) { (finished) -> Void in
                self.mainViewController.contentView.scrollEnabled = true
                self.mainViewController.childViewControllers.first?.view.userInteractionEnabled = true
                if let gestures = self.mainViewController.view.gestureRecognizers {
                    for gesture in gestures {
                        if gesture is UITapGestureRecognizer {
                            self.mainViewController.view.removeGestureRecognizer(gesture)
                        }
                    }
                }
                
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController!.removeFromParentViewController()
        }
    }
}
