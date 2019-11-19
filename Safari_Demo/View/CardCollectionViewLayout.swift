//
//  CardCollectionViewLayout.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/11/19.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit

class CardCollectionViewLayout: UICollectionViewLayout {
    
    weak var delegate: UICollectionViewDelegate?
    weak var dataSource: UICollectionViewDataSource?
    
    /// Set by the view controller when user adds a tab.
    /// When a cell appears, if its index path was equal to this, the animation will differ.
    var addingIndexPath: IndexPath?
    
    /// Set by the view controller when user removes a tab.
    /// When a cell disappears, if its index path was equal to this, the animation will differ.
    var removingIndexPath: IndexPath?
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    
    
    private var layoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private var contentHeight: CGFloat = 0
    
    private let leftRightPadding: CGFloat = 20
    private let minimumAngle: CGFloat = -30
    private let maximumAngle: CGFloat = -80
    private let standardDepth: CGFloat = 200
    private let distanceBetweenItems: CGFloat = 123
    
    var isFullScreen: Bool = false
    var indexOfFullScreen: Int = 0
    
    internal var currentMotionOffset: UIOffset = UIOffset(horizontal: 0, vertical: 0) {
        didSet { self.invalidateLayout() }
    }
    
    override func prepare() {
        super.prepare()
        
        layoutAttributes = [:]
        contentHeight = 0
        
        guard let collectionView = collectionView else {
            return
        }

        let itemWidth = collectionView.bounds.width - (2 * leftRightPadding)
        let scaleFactor: CGFloat = itemWidth / collectionView.bounds.width
        let itemHeight = collectionView.bounds.height * scaleFactor
        
        for section in 0..<collectionView.numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            if itemCount == 0 { continue }
            
            // Distance between items is smaller the more items there are.
            let itemDistance = max(distanceBetweenItems, (collectionView.bounds.height / CGFloat(itemCount)) * 0.8)
            
            for item in 0..<itemCount {
                
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                if isFullScreen {
                    attributes.frame = CGRect(x: 0, y: CGFloat((item - indexOfFullScreen)) * kScreenH, width: kScreenW, height: kScreenH)
                } else {
                    attributes.frame = CGRect(
                        x: (collectionView.bounds.width - itemWidth) / 2,
                        y: CGFloat(item) * itemDistance,
                        width: itemWidth,
                        height: itemHeight
                    )
                    
                    let angle: CGFloat = {
                        let distanceFromTop = attributes.frame.midY + (-1 * collectionView.bounds.midY)
                        let distanceRatio = distanceFromTop / itemHeight
                        let normalisedDistanceRatio = (max(-1, min(1, distanceRatio)) + 1) / 2
                        return minimumAngle + (normalisedDistanceRatio * (maximumAngle - minimumAngle))
                    }()
                    
                    let rotation = CATransform3DMakeRotation(CGFloat.pi * angle / 180, 1, 0, 0)
                    let downTranslation = CATransform3DMakeTranslation(0, 0, -standardDepth)
                    let upTranslation = CATransform3DMakeTranslation(0, 0, standardDepth)
                    var scale = CATransform3DIdentity
                    scale.m34 = -1 / 1200
                    let perspective = CATransform3DConcat(CATransform3DConcat(downTranslation, scale), upTranslation)

                    attributes.transform3D = CATransform3DConcat(rotation, perspective)
                    attributes.zIndex = item
                }
                
                layoutAttributes[indexPath] = attributes
                contentHeight += itemDistance
            }
            
            // Add some extra height so the last item is visible
            contentHeight += itemHeight / 2
        }
    }
    
    override var collectionViewContentSize: CGSize {
        if isFullScreen {
            return CGSize(width: kScreenW, height: kScreenH)
        } else {
            return CGSize(width: collectionView?.frame.size.width ?? 0, height: contentHeight)
        }
        
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.values.filter { rect.intersects($0.frame) }
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else { return nil }
        if self.addingIndexPath == itemIndexPath {
            attributes.transform3D = CATransform3DScale(CATransform3DTranslate(attributes.transform3D, 0, attributes.bounds.height, 0), 0.8, 0.8, 0.8)
        }
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else { return nil }
        if self.removingIndexPath == itemIndexPath {
            attributes.transform3D = CATransform3DTranslate(attributes.transform3D, -attributes.bounds.width, 0, 0)
        }
        return attributes
    }
    
    override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        let attributes = super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
        return attributes
    }
}
