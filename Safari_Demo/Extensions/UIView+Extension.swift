//
//  UIView+Extension.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/10/30.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit


extension UIView {

    //圆角属性
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    /// 截屏Image
    var captureImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, true, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 判断视图类型
    func isKindOfClass(className: String)-> Bool {
        guard let thisClass = NSClassFromString(className) else { return false }
        return self.isKind(of: thisClass)
    }
}

