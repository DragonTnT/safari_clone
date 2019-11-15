//
//  String+extension.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/11/8.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit



extension String {
    //截取从a到b的字符串
    func substring(from a: Int,to b: Int)-> String {
        let startIndex = index(self.startIndex, offsetBy: a)
        let endIndex = index(self.endIndex, offsetBy: -(count - b - 1))
        return String(self[startIndex..<endIndex])
    }
    //给定高度，计算文本宽度
    func calculateWidthWith(height: CGFloat, font: UIFont)-> CGFloat {
        let attr = [NSAttributedString.Key.font: font]
        //文字最大尺寸
        let maxSize: CGSize = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        return self.boundingRect(with: (maxSize), options: option, attributes: attr, context: nil).size.width
    }
}
