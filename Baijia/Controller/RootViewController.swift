//
//  MainViewController.swift
//  Baijia
//
//  Created by mac on 12/10/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class MainViewController: MyViewController {
    
    let leftViewController: UIViewController?
    let mainViewController: UIViewController!
    
    init(leftViewController: UIViewController?, mainViewController: UIViewController!) {
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
        
        self.addChildViewController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:
    func addChildViewController() {
        if self.leftViewController != nil {
            self.addChildViewController(self.leftViewController!)
        }
        self.addChildViewController(self.mainViewController)
        self.view.addSubview(self.mainViewController.view)
    }
}
