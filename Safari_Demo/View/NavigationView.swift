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
        searchBar.frame = CGRect(x: 0, y: statusBarH, width: kScreenW, height: 56)
    }
    
        
    lazy var searchBar: UISearchBar = {
        let it = UISearchBar()
        it.backgroundImage = UIImage()
        it.autocapitalizationType = .none
        it.autocorrectionType = .no
        it.keyboardAppearance = UIKeyboardAppearance.default
        let offSetX = calculateOffsetXOnSearchBar(from: searchBarDefaultHolder)
        it.setPositionAdjustment(UIOffset(horizontal: offSetX, vertical: 0), for: .search)
        return it
    }()
}
