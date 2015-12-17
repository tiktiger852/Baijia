//
//  User.swift
//  Baijia
//
//  Created by mac on 11/29/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    
    let uid: Int?
    let nickname: String?
    let isVerified: Bool?
    let smallLogo: String?
    let isFollowed: Bool?
    let followers: Int?
    let followings: Int?
    let tracks: Int?
    let albums: Int?
    let ptitle: String?
    let personDescribe: String?
    
    init(data: JSON) {
        self.uid = data["uid"].intValue
        self.nickname = data["nickname"].stringValue
        self.isVerified = data["isVerified"].boolValue
        self.smallLogo = data["smallLogo"].stringValue
        self.isFollowed = data["isFollowed"].boolValue
        self.followers = data["followers"].intValue
        self.followings = data["followings"].intValue
        self.tracks = data["tracks"].intValue
        self.albums = data["albums"].intValue
        self.ptitle = data["ptitle"].stringValue
        self.personDescribe = data["personDescribe"].stringValue
    }
}