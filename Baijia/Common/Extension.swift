//
//  Extension.swift
//  Baijia
//
//  Created by mac on 11/12/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

extension Int {
    
    var format: String {
        if self > 10000 {
            let val = String(format: "%.1f", Double(self)/10000) + "万"
            return val
        }
        return String(self)
    }
    
    var formatTime: String {
        let time = Int((NSDate.timestamp - Double(self))/1000)
        if time > 63072000 {
            return "2年前"
        }else if time > 31536000 {
            return "1年前"
        }else if time > 2592000 {
            return "\(Int(time/2592000))个月前"
        }else if time > 86400 {
            return "\(Int(time/86400))天前"
        }else if time > 3600 {
            return "\(Int(time/3600))小时前"
        }else if time > 60 {
            return "\(Int(time/60))分钟前"
        }else {
            return "\(time)秒前"
        }
    }
    
    var formatTime2: String {
        var hours = 0
        var minutes = 0
        var seconds = 0
        
        if self >= 3600 {
            hours = Int(self/3600)
            minutes = Int((self % 3600) / 60)
            seconds = Int((self % 3600) % 60)
        }else {
            minutes = Int(self / 60)
            seconds = Int(self % 60)
        }
        
        if minutes >= 60 {
            seconds = minutes % 60
            minutes = minutes / 60
        }
        
        var string = ""
        if hours > 0 {
            string = "\(hours):"
        }
        if minutes > 9 {
            string += "\(minutes):"
        }else {
            string += "0\(minutes):"
        }
        if seconds > 9 {
            string += "\(seconds)"
        }else {
            string += "0\(seconds)"
        }
        
        return string
    }
}

extension UIImage {
    
    static func fromColor(color: UIColor) -> UIImage? {
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func grayImage() -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
        let context = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, colorSpace, bitmapInfo.rawValue)
        
        if context == nil {
            return nil
        }
        
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage)
        let image = UIImage(CGImage: CGBitmapContextCreateImage(context)!)
        return image
    }
}

extension NSDate {
    
    static var timestamp: Double {
        let date = NSDate(timeIntervalSinceNow: 0)
        let t = date.timeIntervalSince1970
        return Double(String(format: "%.0f", Double(t)))! * 1000
    }
}

extension UIView {
    /*
    func setX(x: CGFloat) {
        var rect = self.frame
        rect.origin.x = x
        self.frame = rect
    }
    
    func setY(y: CGFloat) {
        var rect = self.frame
        rect.origin.y = y
        self.frame = rect
    }
    */
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        
        set {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    
    var maxX: CGFloat {
        get {
            return CGRectGetMaxX(self.frame)
        }
    }
    
    var maxY: CGFloat {
        get {
            return CGRectGetMaxY(self.frame)
        }
    }
    
    var width: CGFloat {
        get {
            return CGRectGetWidth(self.frame)
        }
        
        set {
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
    }
    
    var height: CGFloat {
        get {
            return CGRectGetHeight(self.frame)
        }
        
        set {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
    }
    
    func findViewController() -> UIViewController? {
        return self.traverseResponderChainForUIViewController() as? UIViewController
    }
    
    func traverseResponderChainForUIViewController() -> AnyObject? {
        let nextResponder = self.nextResponder()
        if nextResponder is UIViewController {
            return nextResponder
        }else if nextResponder is UIView {
            return (nextResponder as! UIView).traverseResponderChainForUIViewController()
        }else {
            return nil
        }
    }
}

extension String {
    
    var MD5: String {
        let cString = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let length = CUnsignedInt(
            self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        )
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(
            Int(CC_MD5_DIGEST_LENGTH)
        )
        
        CC_MD5(cString!, length, result)
        
        return String(format:
            "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15])
    }
}

