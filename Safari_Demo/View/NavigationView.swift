//
//  NavigationView.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/11/15.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit

class NavigationView: UIView {

    override init(frame: CGRect) {        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(searchBar)
        
        
        if #available(iOS 13.0, *) {
            searchTextField = searchBar.searchTextField
        } else {
            guard let firstSubView = searchBar.subviews.first else { return }
            for subView in firstSubView.subviews {
                if subView.isKindOfClass(className: "UISearchBarTextField") {
                    searchTextField = subView as? UITextField
                }
                if subView.isKindOfClass(className: "UISearchBarBackground") {
                    subView.alpha = 0
                }
            }
        }
        
        
        
        
        searchTextField.backgroundColor = UIColor(r: 238, g: 238, b: 239)
    }
    
    private func getCancelBtn()-> UIButton? {
        if _cancelBtn == nil {
            guard let firstView = searchBar.subviews.first else { return nil }
            if #available(iOS 13.0, *) {
                guard let lastSubView = firstView.subviews.last else { return nil }
                for subView in lastSubView.subviews {
                    if subView.isKindOfClass(className: "UINavigationButton") {
                        _cancelBtn = subView as? UIButton
                        return subView as? UIButton
                    }
                }
            } else {
               for subView in firstView.subviews {
                   if subView.isKindOfClass(className: "UINavigationButton") {
                        _cancelBtn = subView as? UIButton
                        return subView as? UIButton
                   }
               }
            }
            
        }
        return _cancelBtn
    }
    
        
    lazy var searchBar: UISearchBar = {
        let it = UISearchBar()
        it.frame = CGRect(x: 0, y: statusBarH, width: kScreenW, height: 56)
        it.backgroundImage = UIImage()
        it.autocapitalizationType = .none
        it.autocorrectionType = .no
        it.keyboardAppearance = UIKeyboardAppearance.default
        let offSetX = calculateOffsetXOnSearchBar(from: searchBarDefaultHolder)
        it.setPositionAdjustment(UIOffset(horizontal: offSetX, vertical: 0), for: .search)
        return it
    }()
    
    var searchTextField: UITextField!
    
    
    private var _cancelBtn: UIButton?
    var cancelBtn: UIButton? {
        get {
            return getCancelBtn()
        }
        set {
            _cancelBtn = newValue
        }
        
    }
}
