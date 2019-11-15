//
//  PersonalCollectionView.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/10/31.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit

private let itemLength: CGFloat = (kScreenW - 2 * 20 - 3 * 32)/4

class PersonalCollectionView: UICollectionView {

    init() {
        let frame = CGRect(x: 0, y: navigationH, width: kScreenW, height: kScreenH - navigationH - tabbarH)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemLength, height: itemLength + 50)
        flowLayout.minimumInteritemSpacing = 32
        flowLayout.minimumLineSpacing = 27
        flowLayout.scrollDirection = .vertical
        flowLayout.headerReferenceSize = CGSize(width: kScreenW, height: 73)
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        register(UINib(nibName: "PersonalCollectionCell", bundle: nil), forCellWithReuseIdentifier: PersonalCollectionCell.reuseIndentifier)
        register(PersonalCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PersonalCollectionHeaderView.reuseIndentifier)
        
        
        backgroundColor = UIColor(r: 242, g: 242, b: 246)

        contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        alwaysBounceVertical = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
