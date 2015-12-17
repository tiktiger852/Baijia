//
//  Track.swift
//  Baijia
//
//  Created by mac on 11/15/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Track {
    
    let trackId: Int?
    let uid: Int?
    let bulletSwitchType: Int?
    let playUrl64: String?
    let playUrl32: String?
    let activityId: Int?
    let categoryId: Int?
    let categoryName: String?
    let richIntro: String?
    let downloadUrl: String?
    let playPathAacv164: String?
    let playPathAacv224: String?
    let downloadAacUrl: String?
    let title: String?
    let duration: Int?
    let processState: Int?
    let msg: String?
    let createdAt: Int?
    let coverSmall: String?
    let coverMiddle: String?
    let coverLarge: String?
    let nickname: String?
    let smallLogo: String?
    let userSource: Int?
    let userInfo: User?
    let albumId: Int?
    let albumTitle: String?
    let albumImage: String?
    let images: [String]?
    let isRelay: Bool?
    let ret: Int?
    let trackBlocks: [AnyObject]?
    let tags: String?
    let lyric: String?
    let orderNum: Int?
    let opType: Int?
    let isPublic: Bool?
    let isLike: Bool?
    let likes: Int?
    let playtimes: Int?
    let comments: Int?
    let shares: Int?
    let status: Int?
    let downloadSize: Int?
    let downloadAacSize: Int?
    
    init(data: JSON) {
        self.trackId = data["trackId"].intValue
        self.uid = data["uid"].intValue
        self.bulletSwitchType = data["bulletSwitchType"].intValue
        self.playUrl64 = data["playUrl64"].stringValue
        self.playUrl32 = data["playUrl32"].stringValue
        self.activityId = data["activityId"].intValue
        self.categoryId = data["categoryId"].intValue
        self.categoryName = data["categoryName"].stringValue
        self.richIntro = data["richIntro"].stringValue
        self.downloadUrl = data["downloadUrl"].stringValue
        self.playPathAacv164 = data["playPathAacv164"].stringValue
        self.playPathAacv224 = data["playPathAacv224"].stringValue
        self.downloadAacUrl = data["downloadAacUrl"].stringValue
        self.title = data["title"].stringValue
        self.duration = data["duration"].intValue
        self.processState = data["processState"].intValue
        self.msg = data["msg"].stringValue
        self.createdAt = data["createdAt"].intValue
        self.coverSmall = data["coverSmall"].stringValue
        self.coverMiddle = data["coverMiddle"].stringValue
        self.coverLarge = data["coverLarge"].stringValue
        self.nickname = data["nickname"].stringValue
        self.smallLogo = data["smallLogo"].stringValue
        self.userSource = data["userSource"].intValue
        self.userInfo = User(data: data["userInfo"])
        self.albumId = data["albumId"].intValue
        self.albumTitle = data["albumTitle"].stringValue
        self.albumImage = data["albumImage"].stringValue
        self.images = data["images"].arrayObject as? [String]
        self.isRelay = data["isRelay"].boolValue
        self.ret = data["ret"].intValue
        self.trackBlocks = data["trackBlocks"].arrayObject
        self.tags = data["tags"].stringValue
        self.lyric = data["lyric"].stringValue
        self.orderNum = data["orderNum"].intValue
        self.opType = data["opType"].intValue
        self.isPublic = data["isPublic"].boolValue
        self.isLike = data["isLike"].boolValue
        self.likes = data["likes"].intValue
        self.playtimes = data["playtimes"].intValue
        self.comments = data["comments"].intValue
        self.shares = data["shares"].intValue
        self.status = data["status"].intValue
        self.downloadSize = data["downloadSize"].intValue
        self.downloadAacSize = data["downloadAacSize"].intValue
    }
}