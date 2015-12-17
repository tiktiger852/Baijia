//
//  AlbumIntro.swift
//  Baijia
//
//  Created by mac on 11/15/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AlbumIntro {
    
    let albumId: Int
    let categoryId: Int
    let categoryName: String
    let title: String
    let coverOrigin: String
    let coverSmall: String
    let coverMiddle: String
    let coverLarge: String
    let coverWebLarge: String
    let createdAt: Int
    let updatedAt: Int
    let uid: Int
    let nickname: String
    let isVerified: Bool
    let avatarPath: String
    let intro: String
    let tags: String
    let tracks: Int
    let shares: Int
    let hasNew: Bool
    let isFavorite: Bool
    let playTimes: Int
    let status: Int
    let serializeStatus: Int
    let serialState: Int
    
    init(data: JSON) {
        self.albumId = data["albumId"].intValue
        self.categoryId = data["categoryId"].intValue
        self.categoryName = data["categoryName"].stringValue
        self.title = data["title"].stringValue
        self.coverOrigin = data["coverOrigin"].stringValue
        self.coverSmall = data["coverSmall"].stringValue
        self.coverMiddle = data["coverMiddle"].stringValue
        self.coverLarge = data["coverLarge"].stringValue
        self.coverWebLarge = data["coverWebLarge"].stringValue
        self.createdAt = data["createdAt"].intValue
        self.updatedAt = data["updatedAt"].intValue
        self.uid = data["uid"].intValue
        self.nickname = data["nickname"].stringValue
        self.isVerified = data["isVerified"].boolValue
        self.avatarPath = data["avatarPath"].stringValue
        self.intro = data["intro"].stringValue
        self.tags = data["tags"].stringValue
        self.tracks = data["tracks"].intValue
        self.shares = data["shares"].intValue
        self.hasNew = data["hasNew"].boolValue
        self.isFavorite = data["isFavorite"].boolValue
        self.playTimes = data["playTimes"].intValue
        self.status = data["status"].intValue
        self.serializeStatus = data["serializeStatus"].intValue
        self.serialState = data["serialState"].intValue
    }
}