//
//  LoginViewController.swift
//  Baijia
//
//  Created by mac on 12/11/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class LoginViewController: MyViewController, UITextFieldDelegate {
    
    var username: String?
    var password: String?
    
    @IBOutlet weak var containerView: UIView!
    private var containerViewConstrainTopValue: CGFloat = 0.0
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameClearButton: UIButton!
    @IBOutlet weak var usernameFocusLineView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordClearButton: UIButton!
    @IBOutlet weak var passwordFocusLineView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    @IBOutlet weak var containerViewConstrainTop: NSLayoutConstraint!
    private lazy var navItem: UINavigationItem = {
        
        let backButton = UIButton(type: .Custom)
        backButton.frame = CGRectMake(0, 0, 24, 24)
        backButton.setImage(UIImage(named: "nav_ico_back_white")!, forState: .Normal)
        backButton.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        
        let regButton = UIButton(type: .Custom)
        regButton.frame = CGRectMake(0, 0, 40, 24)
        regButton.setTitle("注册", forState: .Normal)
        regButton.titleLabel?.textColor = UIColor.whiteColor()
        regButton.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        regButton.addTarget(self, action: "register", forControlEvents: .TouchUpInside)
        
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navItem.rightBarButtonItem = UIBarButtonItem(customView: regButton)
        
        return navItem
    }()
    
    private lazy var navBar: UINavigationBar = {
        [unowned self] in
        
        let navBar = UINavigationBar(frame: CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT))
        navBar.subviews.first?.hidden = true
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: RGB(255, 255, 255)]
        navBar.pushNavigationItem(self.navItem, animated: false)
        
        return navBar
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imageName = "left_bg"
        if SCREEN_HEIGHT == 568 {
            imageName = "left_bg-568h"
        }
        self.backgroundImageView.image = UIImage(named: imageName)!.applyBlurWithRadius(15.0, tintColor: nil, saturationDeltaFactor: 1.0, maskImage: nil)
        
        self.view.addSubview(self.navBar)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tap"))
        
        self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "用户名", attributes: [NSForegroundColorAttributeName: RGBA(255, 255, 255, 0.6)])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "密码", attributes: [NSForegroundColorAttributeName: RGBA(255, 255, 255, 0.6)])
        self.loginButton.backgroundColor = RGB(15, 173, 112)
        self.loginButton.layer.cornerRadius = 3.0
        self.forgotPasswordLabel.textColor = RGBA(255, 255, 255, 0.6)
        self.forgotPasswordLabel.userInteractionEnabled = true
        self.forgotPasswordLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "forgotPassword"))
        self.containerViewConstrainTopValue = self.containerViewConstrainTop.constant
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        if SCREEN_HEIGHT == 480 {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    deinit {
        if SCREEN_HEIGHT == 480 {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        }
    }
    
    //MARK:
    func tap() {
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.usernameFocusLineView.alpha = 0.2
        self.passwordFocusLineView.alpha = 0.2
        
        self.containerViewConstrainTop.constant = 0.0
        UIView.animateWithDuration(0.3) { [unowned self]
            () -> Void in
            self.containerView.layoutIfNeeded()
        }
    }
    
    func register() {
        
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func login(sender: AnyObject) {
        guard self.username != nil && self.username?.characters.count > 0 else {
            Util.showErrorHUD("用户名不能为空")
            return
        }
        
        guard self.password != nil && self.password?.characters.count > 0 else {
            Util.showErrorHUD("密码不能为空")
            return
        }
        
        self.loginActivityIndicator.startAnimating()
        self.loginButton.enabled = false
        HttpRequest.sharedInstance.login(self.username!, password: self.password!) { [unowned self] (data) -> Void in
            self.loginButton.enabled = true
            self.loginActivityIndicator.stopAnimating()
            
            guard (data!["ret"] as! Int) == 0 else {
                Util.showErrorHUD(String(data!["msg"]))
                return
            }
            
            let userInfo = [
                "uid": data!["uid"]!,
                "nickname": data!["nickname"]!,
                "largeLogo": data!["largeLogo"]!,
                "middleLogo": data!["middleLogo"]!,
                "smallLogo": data!["smallLogo"]!,
                "token": data!["token"]!
            ]
            Login.sharedInstance.login(userInfo)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func forgotPassword() {
        
    }
    
    
    func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo as! NSDictionary
        if let h = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue.size.height {
            var offsetY: CGFloat = 0.0
            let h2 = SCREEN_HEIGHT - h
            if self.usernameTextField.isFirstResponder() {
                self.usernameTextField.superview?.layoutIfNeeded()
                let posY = (self.usernameTextField.superview?.y)! + (self.usernameTextField.superview?.height)!
                
                offsetY = self.containerViewConstrainTopValue + (h2 - posY) - 20
            }else if self.passwordTextField.isFirstResponder() {
                self.passwordTextField.superview?.layoutIfNeeded()
                let posY = (self.passwordTextField.superview?.y)! + (self.passwordTextField.superview?.height)!
                
                offsetY = self.containerViewConstrainTopValue + (h2 - posY) - 20
            }
            
            if offsetY > 0 {
                offsetY = -offsetY
            }
            
            self.containerViewConstrainTop.constant = offsetY
            UIView.animateWithDuration(0.2, animations: { [unowned self]
                () -> Void in
                self.containerView.layoutIfNeeded()
            })
        }
        
    }
    
    //MARK: - UITextFieldDelegate
    @IBAction func beginEdit(sender: AnyObject) {
        let textField = sender as! UITextField
        if textField == self.usernameTextField {
            self.usernameFocusLineView.alpha = 0.6
            self.passwordFocusLineView.alpha = 0.2
            self.usernameClearButton.hidden = textField.text?.characters.count <= 0
        }else if textField == self.passwordTextField {
            self.usernameFocusLineView.alpha = 0.2
            self.passwordFocusLineView.alpha = 0.6
            self.passwordClearButton.hidden = textField.text?.characters.count <= 0
        }
    }
    
    @IBAction func valueChanged(sender: AnyObject) {
        let textField = sender as! UITextField
        if textField == self.usernameTextField {
            self.usernameClearButton.hidden = textField.text?.characters.count <= 0
        }
        
        if textField == self.passwordTextField {
            self.passwordClearButton.hidden = textField.text?.characters.count <= 0
        }
    }
    
    @IBAction func endEdit(sender: AnyObject) {
        let textField = sender as! UITextField
        if textField == self.usernameTextField {
            self.usernameClearButton.hidden = true
            self.username = textField.text!
        }
        
        if textField == self.passwordTextField {
            self.passwordClearButton.hidden = true
            self.password = textField.text!
        }
    }
    
    @IBAction func clearUsernameTextField(sender: AnyObject) {
        self.usernameTextField.text = nil
        self.username = nil
    }
    
    @IBAction func clearPasswordTextField(sender: AnyObject) {
        self.passwordTextField.text = nil
        self.password = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.usernameTextField {
            self.usernameTextField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
        }else if textField == self.passwordTextField {
            self.usernameTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
            
            self.containerViewConstrainTop.constant = 0.0
            UIView.animateWithDuration(0.2) { [unowned self]
                () -> Void in
                self.containerView.layoutIfNeeded()
            }
        }
        return true
    }
}
