//
//  Util.swift
//  Baijia
//
//  Created by mac on 11/26/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation
import MBProgressHUD

final class Util {

    static func showErrorHUD(tipString: String!) {
        let hud = MBProgressHUD.showHUDAddedTo(KEY_WINDOW, animated: true)
        hud.mode = .Text
        hud.detailsLabelFont = UIFont.systemFontOfSize(15)
        hud.detailsLabelText = tipString
        hud.margin = 10
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 1.5)
    }
    
    static func showTipHUD(tipString: String!, view: UIView!) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.detailsLabelFont = UIFont.systemFontOfSize(15)
        hud.detailsLabelText = tipString
        hud.margin = 10
        hud.removeFromSuperViewOnHide = true
    }
    
    static func hideHUD(view: UIView!) {
        MBProgressHUD.hideAllHUDsForView(view, animated: true)
    }
    
    static func baseurl() -> String! {
        return ENV == "Prod" ? BASE_URL : TEST_BASE_URL
    }
}