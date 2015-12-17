//
//  ViewController.swift
//  Baijia
//
//  Created by mac on 11/10/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var playNeedleImageView: UIImageView?
    
    var button: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playNeedleImageView = UIImageView(frame: CGRectMake(118.5, -20.0, 80, 140))
        //self.playNeedleImageView!.center = self.view.center
        self.playNeedleImageView!.image = UIImage(named: "cm2_play_needle_play")
        self.playNeedleImageView!.layer.anchorPoint = CGPointMake(0.16, 0.12)
        self.playNeedleImageView!.transform = CGAffineTransformMakeRotation(CGFloat(-0.5))
        self.view.addSubview(self.playNeedleImageView!)
        
        self.button = UIButton(frame: CGRectMake(0, 0, 100, 50))
        self.button!.center = self.view.center
        self.button!.y = 300
        self.button!.backgroundColor = UIColor.purpleColor()
        self.button!.setTitle("Button", forState: .Normal)
        self.button!.addTarget(self, action: "buttonClicked", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.button!)
    }
    
    func buttonClicked() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.Linear)
        UIView.setAnimationDuration(5.0)
        self.playNeedleImageView!.transform = CGAffineTransformRotate(self.playNeedleImageView!.transform, CGFloat(0.5))
        UIView.commitAnimations()
        
    }
}

