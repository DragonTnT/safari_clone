//
//  MainViewController.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/11/19.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit

class MainViewController: CardCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        // Do any additional setup after loading the view.
        
        for _ in 0...2 {
            let webVC = WebViewController()
            webVC.delegate = self
            addChild(webVC)
        }
    }

}

extension MainViewController: CardCollectionViewControllerDataSource {
    func numberOfTabsInTiltedTabViewController() -> Int {
            return children.count
        }
        
    func snapshotForTab(atIndex index: Int) -> UIImage? {
        return children[index].view.captureImage
    }
    
    func titleForTab(atIndex index: Int) -> String? {
        return children[index].title
    }
    
    func indexForActiveTab() -> Int? {
        return nil
    }
    
    func tabAdded(atIndex index: Int) {
        
    }
    
    func tabRemoved(atIndex index: Int) {
//        let vc = children[index]
//        vc.removeFromParent()
//        vc.view.removeFromSuperview()
    }
    
    func tabMoved(fromIndex: Int, toIndex: Int) {
        
    }
}

extension MainViewController: CardCollectionViewControllerDelegate {
    func tabSelected(atIndex index: Int) {
        let subVC = children[index]
        if subVC.view.superview == nil {
            view.addSubview(subVC.view)
        }
        view.bringSubviewToFront(subVC.view)
    }
}

extension MainViewController: WebViewControllerDelegate {
    func webViewControllerDidClickSwitch(_ controller: WebViewController) {
        controller.view.removeFromSuperview()
        guard let index = children.firstIndex(of: controller) else { return }
        let indexPath = IndexPath(item: index, section: 0)
        showCollectionViewWith(indexPath: indexPath)
    }
}
