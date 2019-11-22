//
//  FullScreenLayout.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/11/21.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit

class FullScreenLayout: UICollectionViewLayout {
    
    var indexOfFullScreen: Int = 0
    private var contentHeight: CGFloat = 0
    
    private var layoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    
    override func prepare() {
        super.prepare()
        
        layoutAttributes = [:]
        contentHeight = 0
        
        guard let collectionView = collectionView else {
            return
        }

        for section in 0..<collectionView.numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            if itemCount == 0 { continue }
            
            for item in 0..<itemCount {
                
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//                if item == indexOfFullScreen {
//                    attributes.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
//                }
                attributes.frame = CGRect(x: 0, y: CGFloat(item - indexOfFullScreen) * kScreenH, width: kScreenW, height: kScreenH)
                attributes.zIndex = item
                layoutAttributes[indexPath] = attributes
            }
            
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: kScreenW, height: 5 * kScreenH)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.values.filter { rect.intersects($0.frame) }
    }
}
