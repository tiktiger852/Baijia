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

class Http {
    
    class func getRecommendList(callback: JSON?->Void) {
        let urlString = BASE_URL + "/discovery/v2/category/recommends?categoryId=14&contentType=album&device=iPhone&scale=2&version=4.3.20"
        Alamofire.request(.GET, urlString)
            .response { (req, resp, data, error) -> Void in
                if error == nil && data != nil {
                    let json = JSON(data: data!)
                    callback(json)
                }else {
                    callback(nil)
                }
        }
    }
}