//
//  Http.swift
//  Baijia
//
//  Created by mac on 11/11/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private enum NetworkMethod {
    case Get
    case Post
}

final class HttpRequest {
    private var baseurl: String!
    private var alamofireManager: Alamofire.Manager!
    
    static let sharedInstance: HttpRequest = {
        let baseurl = Util.baseurl()
        
        return HttpRequest(baseurl:baseurl)
    }()
    
    init(baseurl: String!) {
        self.baseurl = baseurl
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 30
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
    }
    
    func getRecommendList(callback: ([Banner], [[Any]])? -> Void) {
        let urlString = "/discovery/v2/category/recommends?categoryId=14&contentType=album&device=iPhone&scale=2&version=4.3.20"
        
        self.requestJSONData(.Get, urlString: urlString, parameters: nil, headers: nil) { (json) -> Void in
            if let data = json {
                var info = [[Any]]()
                
                var banners = [Banner]()
                for (_, subjson) in data["focusImages"]["list"] {
                    let banner = Banner(data: subjson)
                    banners.append(banner)
                }
                
                for (key, subjson) in data["categoryContents"]["list"] {
                    var section = [Any]()
                    
                    if Int(key)! == 0 {
                        continue
                    }
                    
                    section.append("")
                    
                    let title = [
                        "title": subjson["title"].stringValue,
                        "moduleType": subjson["moduleType"].intValue,
                        "tagName": subjson["tagName"].stringValue,
                        "hasMore": subjson["hasMore"].boolValue
                    ]
                    
                    section.append(title)
                    
                    for (_, subjson) in subjson["list"] {
                        let album = Album(data: subjson)
                        section.append(album)
                    }
                    info.append(section)
                }
                
                callback((banners, info))
            }else {
                callback(nil)
            }
        }
    }
    
    func getTag(tagName tagName: String!, calcDimension: String!,  pageId: Int, callback: [String: Any]? -> Void) {
        let urlString = "/discovery/v1/category/album?calcDimension=\(calcDimension)&categoryId=14&device=iPhone&pageId=\(pageId)&pageSize=20&status=0&tagName=\(tagName)"
        
        self.requestJSONData(.Get, urlString: urlString, parameters: nil, headers: nil) { (json) -> Void in
            if let data = json {
                var info = [String: Any]()
                var list = [Album]()
                
                if !data["list"].isEmpty {
                    for (_, subjson) in data["list"] {
                        let album = Album(data: subjson)
                        list.append(album)
                    }
                    info["list"] = list
                }
                info["title"] = data["title"].stringValue
                info["totalCount"] = data["totalCount"].intValue
                info["pageId"] = data["pageId"].intValue
                info["maxPageId"] = data["maxPageId"].intValue
                info["pageSize"] = data["pageSize"].intValue
                
                callback(info)
            }else {
                callback(nil)
            }
        }
    }

    func getAlbumInfo(albumId albumId: Int, pageId: Int, callback: (AlbumIntro, [[Any]], [String: Int])? -> Void) {
        let urlString = "/others/ca/album/track/\(albumId)/true/\(pageId)/10?device=iPhone"

        self.requestJSONData(.Get, urlString: urlString, parameters: nil, headers: nil) { (json) -> Void in
            if let data = json {
                if data["ret"].intValue == 0 {
                    var info = [[Any]]()
                    
                    let albumIntro = AlbumIntro(data: data["album"])
                    
                    if data["tracks"]["pageId"].intValue <= data["tracks"]["maxPageId"].intValue {
                        var tracks = [Any]()
                        for (_, subjson) in data["tracks"]["list"] {
                            let track = Track(data: subjson)
                            tracks.append(track)
                        }
                        info.append(tracks)
                    }
                    
                    let config = [
                        "pageId": data["tracks"]["pageId"].intValue,
                        "pageSize": data["tracks"]["pageSize"].intValue,
                        "maxPageId": data["tracks"]["maxPageId"].intValue,
                        "totalCount": data["tracks"]["totalCount"].intValue
                    ]
                    
                    callback((albumIntro, info, config))
                }else {
                    callback(nil)
                }
            }else {
                callback(nil)
            }
        }
    }
    
    func getTrackInfo(trackId: Int!, callback: Track? -> Void) {
        let urlString = "/track/detail?device=iPhone&trackId=\(trackId)"
        
        self.requestJSONData(.Get, urlString: urlString, parameters: nil, headers: nil) { (json) -> Void in
            if json != nil {
                let track = Track(data: json!)
                callback(track)
            }else {
                callback(nil)
            }
        }
    }
        
    func getPlaylist(albumId: Int!, callback: [String: Any]? -> Void) {
        let urlString = "/playlist/album?albumId=\(albumId)&device=iPhone"
        
        self.requestJSONData(.Get, urlString: urlString, parameters: nil, headers: nil) { (json) -> Void in
            if json != nil {
                var tracks = [Track]()
                for (_, subjson) in json!["data"] {
                    tracks.append(Track(data: subjson))
                }
                let dict: [String: Any] = [
                    "albumTitle": json!["albumTitle"].stringValue,
                    "playlist": tracks
                ]
                callback(dict)
            }else {
                callback(nil)
            }
        }
    }
    
    func login(username: String!, password: String!, callback:[String: AnyObject]? -> Void) {
        let urlString = "/login"
        let parameters = [
            "account": username,
            "password": password,
            "device": "iPhone"
        ]
        self.requestJSONData(.Post, urlString: urlString, parameters: parameters, headers: nil) { (json) -> Void in
            guard json != nil else {
                callback(nil)
                return
            }
            
            let dict = json!.dictionaryObject
            callback(dict)
        }
    }
    
    private func requestJSONData(method: NetworkMethod, urlString: String!, parameters: [String: AnyObject]?, headers: [String: String]?, callback: JSON? -> Void) {
        let netType = self.checkNetStatus()
        if netType == nil {
            Util.showErrorHUD("网络连接异常")
            callback(nil)
            return
        }
        var urlString2 = self.baseurl + urlString
        urlString2 = urlString2.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        var param = [String: AnyObject]()
        if parameters != nil {
            param = parameters!
        }
        param["network"] = netType!

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        switch(method) {
            case .Get:
                self.alamofireManager.request(.GET, urlString2, parameters: param, encoding: .URL, headers: headers)
                    .response(completionHandler: { (req, resp, data, error) -> Void in
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        if error != nil {
                            self.handleError(error!)
                            callback(nil)
                        }else {
                            let json = JSON(data: data!)
                            callback(json)
                        }
                    })
            case .Post:
                self.alamofireManager.request(.POST, urlString2, parameters: param, encoding: .URL, headers: headers)
                    .response(completionHandler: { (req, resp, data, error) -> Void in
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        if error != nil {
                            self.handleError(error!)
                            callback(nil)
                        }else {
                            let json = JSON(data: data!)
                            callback(json)
                        }
                    })
        }
    }
    
    private func checkNetStatus() -> String? {
        let netStatus = (UIApplication.sharedApplication().delegate as! AppDelegate).reach!.currentReachabilityStatus().rawValue
        if netStatus != 0 {
            return netStatus == 2 ? "WIFI" : "Cellular"
        }
        return nil
    }
    
    private func handleError(error: NSError!) {
        let errorCode = error.code
        print(error)
        switch(errorCode) {
            case 1001:
                Util.showErrorHUD("网络连接超时")
            default:
                Util.showErrorHUD("网络错误")
        }
    }
}