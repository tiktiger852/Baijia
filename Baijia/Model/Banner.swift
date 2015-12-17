//
//  Banner.swift
//  Baijia
//
//  Created by mac on 11/15/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Banner {
    
    let albumId: Int?
    let trackId: Int?
    let pic: String
    let type: Int
    
    init(data: JSON) {
        self.albumId = data["albumId"].intValue
        self.trackId = data["trackId"].intValue
        self.pic = data["pic"].stringValue
        self.type = data["type"].intValue
    }
}