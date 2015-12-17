//
//  MyNavigationController.swift
//  Baijia
//
//  Created by mac on 11/21/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        if self.respondsToSelector("interactivePopGestureRecognizer") {
            self.interactivePopGestureRecognizer?.delegate = self
            self.delegate = self
        }
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if self.respondsToSelector("interactivePopGestureRecognizer") {
            self.interactivePopGestureRecognizer?.enabled = false
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    //MARK: UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if self.respondsToSelector("interactivePopGestureRecognizer") {
            self.interactivePopGestureRecognizer?.enabled = true
        }
    }
}
