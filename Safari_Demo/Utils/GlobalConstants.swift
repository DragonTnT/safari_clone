//
//  GlobalConstants.swift
//  AppStoreDemo
//
//  Created by Allen long on 2019/8/2.
//  Copyright © 2019 Utimes. All rights reserved.
//

import UIKit

enum GlobalConstants {
}


let kScreenH = UIScreen.main.bounds.size.height
let kScreenW = UIScreen.main.bounds.size.width
let statusBarH = UIApplication.shared.statusBarFrame.height
let navigationH: CGFloat = 100
let tabbarToBottom: CGFloat = hasTopNotch() ? 34 : 0
let tabbarH: CGFloat =  tabbarToBottom + 49
var keyWindow: UIWindow {
    if #available(iOS 13.0, *) {
        return UIApplication.shared.windows.first!
    } else {
        return UIApplication.shared.keyWindow!
    }
}


let kBtnDisableDColor: UIColor = UIColor(r: 206, g: 206, b: 207)
let kBtnAbledColor: UIColor = UIColor(r: 206, g: 206, b: 207)

