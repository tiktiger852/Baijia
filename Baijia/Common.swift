//
//  Consts.swift
//  Baijia
//
//  Created by mac on 11/11/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
let SCREEN_WIDTH = SCREEN_BOUNDS.size.width
let SCREEN_HEIGHT = SCREEN_BOUNDS.size.height
let SCREEN_WIDTH_2 = SCREEN_WIDTH/2
let SCREEN_HEIGHT_2 = SCREEN_HEIGHT/2
let NAVBAR_HEIGHT = CGFloat(64)


let KEY_WINDOW = UIApplication.sharedApplication().keyWindow!

let BASE_URL = "http://mobile.ximalaya.com/mobile"
let TEST_BASE_URL = "http://120.25.90.218:8080"
let ENV = "Prod"


let LOAD_MORE_TEXT = "加载更多"
let LOAD_COMPLETE_TEXT = "加载完成"

func RGBA(r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
    return UIColor(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: a)
}

func RGB(r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    return RGBA(r, g, b, 1.0)
}

func image(string: String!) -> UIImage? {
    return UIImage(named: string)
}

func url(string: String!) -> NSURL? {
    return NSURL(string: string)
}