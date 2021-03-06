//
//  GlobalFunctions.swift
//  AppStoreDemo
//
//  Created by Allen long on 2019/8/2.
//  Copyright © 2019 Utimes. All rights reserved.
//

import UIKit

/// Judge whether the phone has a top notch
func hasTopNotch()-> Bool {
    if #available(iOS 11.0, *) {
        let top = UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
        return top < CGFloat(24) ? false : true
    } else {
        return false
    }
}

/// delay action
func delay(_ timeInterval: TimeInterval, closure: @escaping()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval) {
        closure()
    }
}


//计算searchBar中占位的偏移量
func calculateOffsetXOnSearchBar(from holder: String)-> CGFloat {
    let hostWidth: CGFloat = holder.calculateWidthWith(height: 20, font: UIFont.systemFont(ofSize: 16))
    return ((kScreenW - 2 * 20) - hostWidth - 50)/2.0
}
