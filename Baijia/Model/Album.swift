//
//  Album.swift
//  Baijia
//
//  Created by mac on 11/11/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation
import SwiftyJSON


struct Album {
    
    let id: Int
    let albumId: Int
    let uid: Int
    let intro: String
    let nickname: String
    let albumCoverUrl290: String
    let coverMiddle: String
    let title: String
    let tags: String
    let tracks: Int
    let tracksCounts: Int
    let playsCounts: Int
    let lastUptrackId: Int
    let lastUptrackTitle: String
    let lastUptrackAt: Int
    let isFinished: Int
    let serialState: Int
    
    init(data: JSON) {
        self.id = data["id"].intValue
        self.albumId = data["albumId"].intValue
        self.uid = data["uid"].intValue
        self.intro = data["intro"].stringValue
        self.nickname = data["nickname"].stringValue
        self.albumCoverUrl290 = data["albumCoverUrl290"].stringValue
        self.coverMiddle = data["coverMiddle"].stringValue
        self.title = data["title"].stringValue
        self.tags = data["tags"].stringValue
        self.tracks = data["tracks"].intValue
        self.tracksCounts = data["tracksCounts"].intValue
        self.playsCounts = data["playsCounts"].intValue
        self.lastUptrackId = data["lastUptrackId"].intValue
        self.lastUptrackTitle = data["lastUptrackTitle"].stringValue
        self.lastUptrackAt = data["lastUptrackAt"].intValue
        self.isFinished = data["isFinished"].intValue
        self.serialState = data["serialState"].intValue
    }
}