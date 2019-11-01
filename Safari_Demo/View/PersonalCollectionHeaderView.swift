//
//  PersonalCollectionHeaderView.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/11/1.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit

class PersonalCollectionHeaderView: UICollectionReusableView {
    
    var titleLabel = UILabel()

    static let reuseIndentifier = "PersonalCollectionHeaderView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        titleLabel.frame = CGRect(x: 0, y: 36, width: 200, height: 25)
        
        addSubview(titleLabel)
    }
}
