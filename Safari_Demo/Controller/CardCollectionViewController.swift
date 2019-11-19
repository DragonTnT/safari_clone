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
    func tabAdded(atIndex index: Int)
    
    /// Called when a tab was closed by the user. Remove it from data storage.
    func tabRemoved(atIndex index: Int)
    
    /// Called when a tab was moved by the user. Move it in the data storage.
    func tabMoved(fromIndex: Int, toIndex: Int)
}

/// Conform to this delegate protocol to know when the tilted tab view does things.
public protocol CardCollectionViewControllerDelegate: class {
    
    /// The user tapped on the tab at the given index.
    func tabSelected(atIndex index: Int)

}

class CardCollectionViewController: UICollectionViewController {
    
    public weak var dataSource: CardCollectionViewControllerDataSource?
    public weak var delegate: CardCollectionViewControllerDelegate?
    public var selectedIndexOfSubVC: Int = 0
    
    /// Create a new tilted tab view controller.
    public init() {
        let layout = CardCollectionViewLayout()
        super.init(collectionViewLayout: layout)
        layout.delegate = self
        layout.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    

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
        collectionView.collectionViewLayout = layout
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var layout: CardCollectionViewLayout = {
        let layout = CardCollectionViewLayout()
        layout.delegate = self
        layout.dataSource = self
        self.collectionView?.collectionViewLayout = layout
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
        dataSource?.tabAdded(atIndex: index)
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
    }
    
    
    func showFullScreenWith(indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        cell.hideHeaderView()
        
        guard let layout = collectionView.collectionViewLayout as? CardCollectionViewLayout else { return }
        layout.isFullScreen = true
        layout.indexOfFullScreen = indexPath.item
        
        collectionView.performBatchUpdates(nil) { (finished) in
            if finished {
                self.delegate?.tabSelected(atIndex: indexPath.item)
            }
        }
        
        selectedIndexOfSubVC = indexPath.item
    }
    
    func showCollectionViewWith(indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        cell.showHeaderView()
            
        let layout = collectionView.collectionViewLayout as! CardCollectionViewLayout
        layout.isFullScreen = false

        //在完成layout布局后，再次调用reloadData。是为了防止点击cell顺序不对的bug
        collectionView.performBatchUpdates(nil) { (finished) in
            if finished {
                self.collectionView.reloadData()
            }
        }
    }
}
