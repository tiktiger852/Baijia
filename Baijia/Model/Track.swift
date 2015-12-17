//
//  Track.swift
//  Baijia
//
//  Created by mac on 11/15/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation

struct Track {
    
    let trackId: Int
    let uid: Int
    let playUrl64: String
    let playUrl32: String
    let downloadUrl: String
    let playPathAacv164: String
    let playPathAacv224: String
    let downloadAacUrl: String
    let title: String
    let duration: Int
    let processState: Int
    let createdAt: Int
    let coverSmall: String
    let coverMiddle: String
    let coverLarge: String
    let nickname: String
    let smallLogo: String
    let userSource: Int
    let albumId: Int
    let albumTitle: String
    let albumImage: String
    let orderNum: Int
    let opType: Int
    let isPublic: Bool
    let likes: Int
    let playtimes: Int
    let comments: Int
    let shares: Int
    let status: Int
    let downloadSize: Int
    let downloadAacSize: Int
}