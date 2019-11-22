//
//  CardCollectionViewController.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/11/19.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit

/// Conform to this data source protocol to provide the tilted tab view data.
public protocol CardCollectionViewControllerDataSource: class {
    
    /// How many tabs are present in the tab view
    func numberOfTabsInTiltedTabViewController() -> Int
    
    /// Provide an image to display in the tab. Use UIGraphicsImageRenderer to render a view's hierarchy to retrieve a snapshot before presenting the tab view, cache it, and return it here.
    func snapshotForTab(atIndex index: Int) -> UIImage?
    
    /// The title to be displayed on the tab
    func titleForTab(atIndex index: Int) -> String?
    
    /// Used for presentation/dismissal. The tab view will animate the tab at this index in and out.
    func indexForActiveTab() -> Int?
    
    /// Called when a tab was manually added. Add a new tab to data storage.
    func tabAdded()
    
    /// Called when a tab was closed by the user. Remove it from data storage.
    func tabRemoved(atIndex index: Int)
    
    /// Called when a tab was moved by the user. Move it in the data storage.
    func tabMoved(fromIndex: Int, toIndex: Int)
}

/// Conform to this delegate protocol to know when the tilted tab view does things.
public protocol CardCollectionViewControllerDelegate: class {
    
    func tapWillSelect(atIndex index: Int)
    /// The user tapped on the tab at the given index.
    func tabSelected(atIndex index: Int)

    func tabHasCleared()
}

class CardCollectionViewController: UICollectionViewController {
    
    public weak var dataSource: CardCollectionViewControllerDataSource?
    public weak var delegate: CardCollectionViewControllerDelegate?
    public var selectedIndexOfSubVC: Int = 0

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let collectionView = self.collectionView else {
            assertionFailure("Collection view not found in UICollectionViewController")
            return
        }
        collectionView.backgroundColor = UIColor(white: 0.2, alpha: 1)
        
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.reuseIndentifier)
        collectionView.collectionViewLayout = fullScreenLayout
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    lazy var cardLayout: SafariIPhoneCollectionViewLayout = {
        let layout = SafariIPhoneCollectionViewLayout()
        self.collectionView?.collectionViewLayout = layout
        return layout
    }()
    
    lazy var fullScreenLayout: FullScreenLayout = {
        let layout = FullScreenLayout()
        return layout
    }()
}

// MARK: - collectionViewDataSource,collectionViewDelegate
extension CardCollectionViewController {
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfTabsInTiltedTabViewController() ?? 0
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIndentifier, for: indexPath) as! CardCollectionViewCell
        
        cell.delegate = self
        cell.title = dataSource?.titleForTab(atIndex: indexPath.item)
        cell.snapshot = dataSource?.snapshotForTab(atIndex: indexPath.item)
        
        return cell
    }
    
    open override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataSource?.tabMoved(fromIndex: sourceIndexPath.item, toIndex: destinationIndexPath.item)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.tapWillSelect(atIndex: indexPath.item)
        showFullScreenWith(indexPath: indexPath)
    }

}
// MARK: - CardCollectionViewCellDelegate
extension CardCollectionViewController: CardCollectionViewCellDelegate {
    
    func cardCollectionViewCellCloseButtonTapped(_ cell: CardCollectionViewCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else {
            return
        }
        self.removeTab(atIndex: indexPath.item)
    }
}


// MARK: - Helper
extension CardCollectionViewController {
    /// Add a new tab at the given index. Be sure to also add a model for this tab to the data source's model.
    /// The tabAdded data source method will be called by this method.
    public func addTab(atIndex index: Int) {
        dataSource?.tabAdded()
        let indexPath = IndexPath(item: index, section: 0)
        let layout = self.collectionView?.collectionViewLayout as? CardCollectionViewLayout
        layout?.addingIndexPath = indexPath
        self.collectionView?.insertItems(at: [indexPath])
        self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        layout?.addingIndexPath = nil
    }
    
    /// Remove the tab at the given index. Be sure to also remove the model for this tab from the data source's model.
    /// The tabRemoved data source method will be called by this method.
    public func removeTab(atIndex index: Int) {
        dataSource?.tabRemoved(atIndex: index)
        let indexPath = IndexPath(item: index, section: 0)
        let layout = self.collectionView?.collectionViewLayout as? CardCollectionViewLayout
        layout?.removingIndexPath = indexPath
        self.collectionView?.deleteItems(at: [indexPath])        
        layout?.removingIndexPath = nil
        
        if collectionView.numberOfItems(inSection: 0) == 0 {
            delegate?.tabHasCleared()
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.insertItems(at: [indexPath])
            layout?.isFullScreen = true
            layout?.indexOfFullScreen = 0
            collectionView.reloadData()
        }
    }
    
    
    func showFullScreenWith(indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        cell.hideHeaderView()
        fullScreenLayout.indexOfFullScreen = indexPath.item
        
        collectionView.setCollectionViewLayout(fullScreenLayout, animated: true) { (finished) in
            self.delegate?.tabSelected(atIndex: indexPath.item)
        }
        selectedIndexOfSubVC = indexPath.item
    }
    
    func showCollectionViewWith(indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        cell.showHeaderView()

        //在完成layout布局后，再次调用reloadData。是为了防止点击cell顺序不对的bug
        collectionView.setCollectionViewLayout(cardLayout, animated: true) { (isFinished) in
            self.collectionView.reloadData()
        }
    }
}
