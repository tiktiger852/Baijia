//
//  Login.swift
//  Baijia
//
//  Created by mac on 12/11/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation

class Login: NSObject {
    
    var nickname: String? {
        get {
            if let key = NSUserDefaults.standardUserDefaults().stringForKey("current_login_user") {
                if let allLoginUsers = self.readAllLoginUser() {
                    let user = allLoginUsers[key] as! [String: AnyObject]
                    return user["nickname"] as? String
                }
            }
            return nil
        }
    }
    
    var avatar: String? {
        get {
            if let key = NSUserDefaults.standardUserDefaults().stringForKey("current_login_user") {
                if let allLoginUsers = self.readAllLoginUser() {
                    let user = allLoginUsers[key] as! [String: AnyObject]
                    return user["middleLogo"] as? String
                }
            }
            return nil
        }
    }
    
    static let sharedInstance: Login = {
        let instance = Login()
        return instance
    }()
    
    private override init() {}
    
    
    func login(user: [String: AnyObject]) {
        self.updateLoginUser(user)
    }
    
    func isLogin() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey("login_status")
    }
    
    func logout() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: "login_status")
        defaults.synchronize()
    }
    
    private func readAllLoginUser() -> [String: AnyObject]? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.dictionaryForKey("login_users")
    }
    
    private func updateLoginUser(user: [String: AnyObject]) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setBool(true, forKey: "login_status")
        defaults.setObject(String(user["uid"]).MD5, forKey: "current_login_user")
        defaults.setObject(user["token"], forKey: "token")
        
        var allLoginUser = self.readAllLoginUser()
        if allLoginUser == nil {
            allLoginUser = [String: AnyObject]()
        }
        let key = String(user["uid"]).MD5
        allLoginUser![key] = user
        defaults.setObject(allLoginUser!, forKey: "login_users")
        defaults.synchronize()
    }
}