//
//  WebViewController.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/10/29.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController {
    
    private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true
        setupWebView()
        
        keyWindow.addSubview(TabbarView.shared)
        
        
        navigationItem.titleView = searchBar
    
    }
    

    //浏览器
    lazy var webView: WKWebView = {
        let frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
        let it = WKWebView(frame: frame)
        let urlRequest = URLRequest(url: URL(string: "https://www.baidu.com")!)
        it.navigationDelegate = self
        it.load(urlRequest)
        return it
    }()

    
    lazy var searchBar: UISearchBar = {
        let it = UISearchBar()
        it.autocapitalizationType = .none
        it.autocorrectionType = .no
        it.keyboardAppearance = UIKeyboardAppearance.default
        it.placeholder = "搜索或输入网站名称"
        it.delegate = self
        it.setPositionAdjustment(UIOffset(horizontal: placeholderOffsetX, vertical: 0), for: .search)
        it.searchTextField.clearButtonMode = .whileEditing
        return it
    }()
    
    private lazy var personalCollectionView: PersonalCollectionView = {
        let it = PersonalCollectionView()
        it.delegate = self
        it.dataSource = self
        return it
    }()
    
    //配置webView
    private func setupWebView() {
        view.addSubview(webView)
        
        webView.addObserver(self, forKeyPath: loadingKey, options: .new, context: nil)
    }
    
    //根据searchBar当前的状态来改变它的UI
    private func changeSearchBarUI(isEditing: Bool) {
        if isEditing {
            addPersonalView()
            searchBar.setShowsCancelButton(true, animated: true)
            searchBar.setPositionAdjustment(UIOffset.zero, for: .search)
        } else {
            hidePersonalView()
            searchBar.setShowsCancelButton(false, animated: true)
            searchBar.setPositionAdjustment(UIOffset(horizontal: placeholderOffsetX, vertical: 0), for: .search)
        }
    }
    
    private func addPersonalView() {
        if personalCollectionView.superview == nil {
            view.addSubview(personalCollectionView)
        }
        UIView.animate(withDuration: 0.1) {
            self.personalCollectionView.alpha = 1
            self.personalCollectionView.transform = CGAffineTransform.identity
        }
    }
    
    private func hidePersonalView() {
        UIView.animate(withDuration: 0.1) {
            self.personalCollectionView.alpha = 0
            self.personalCollectionView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == loadingKey {
            if let change = change, let loading = change[NSKeyValueChangeKey.newKey] as? Bool {
                print(loading)
            }
        }
    }
    
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finished")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("fail")
    }
}


extension WebViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        changeSearchBarUI(isEditing: true)
        return true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        changeSearchBarUI(isEditing: false)
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            if let url = URL(string: text) {
                let request = URLRequest(url: url)
                webView.load(request)
                searchBar.resignFirstResponder()
            }
        }
    }
}

extension WebViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonalCollectionCell.reuseIndentifier, for: indexPath) as! PersonalCollectionCell
        cell.model = dataSource[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PersonalCollectionHeaderView.reuseIndentifier, for: indexPath) as! PersonalCollectionHeaderView
        headerView.titleLabel.text = "个人收藏"
        headerView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 73)
        return headerView
    }
    
}

private let dataSource: [PersonalModel] = [
    PersonalModel(name: "1", iconImageName: "logo_broadcast"),
    PersonalModel(name: "2", iconImageName: "logo_car"),
    PersonalModel(name: "3", iconImageName: "logo_game"),
    PersonalModel(name: "4", iconImageName: "logo_jump"),
    PersonalModel(name: "5", iconImageName: "logo_smile"),
    PersonalModel(name: "6", iconImageName: "logo_weibo")
]

private let placeholderOffsetX: CGFloat = ((kScreenW - 2 * 20) - 190)/2.0

private let loadingKey = "loading"
