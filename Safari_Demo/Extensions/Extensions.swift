//
//  Extensions.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/11/12.
//  Copyright © 2019 autocareai. All rights reserved.
//

import Foundation
import UIKit
import WebKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension WKWebView {
    func loadURLString(_ string: String) {
        guard let url = URL(string: string) else { return }
        let request = URLRequest(url: url)
        load(request)
    }
}

