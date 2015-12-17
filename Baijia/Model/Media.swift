//
//  Media.swift
//  Baijia
//
//  Created by mac on 12/4/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation

class Media: NSObject, DOUAudioFile {
    
    var title: String!
    var urlString: String!
    
    init(title: String!, urlString: String!) {
        self.title = title
        self.urlString = urlString
    }
    
    func audioFileURL() -> NSURL! {
        return NSURL(string: self.urlString)!
    }
}