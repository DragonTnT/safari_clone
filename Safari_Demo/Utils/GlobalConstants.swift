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
let navigationH: CGFloat = statusBarH + 56
let tabbarToBottom: CGFloat = hasTopNotch() ? 34 : 0
let tabbarH: CGFloat =  tabbarToBottom + 49
let searchBarDefaultHolder: String = "搜索或输入网站名称"
var keyWindow: UIWindow {
    if #available(iOS 13.0, *) {
        return UIApplication.shared.windows.first!
    } else {
        return UIApplication.shared.keyWindow!
    }
}


let kBtnDisableDColor: UIColor = UIColor(r: 206, g: 206, b: 207)    //CECECF
let kBtnAbledColor: UIColor = UIColor(r: 0, g: 121, b: 255)         //0079FF
let kTextGray: UIColor = UIColor(r: 143, g: 143, b: 144)            //8F8F90
let kTextBlack: UIColor = UIColor(r: 23, g: 25, b: 31)              //17191F
