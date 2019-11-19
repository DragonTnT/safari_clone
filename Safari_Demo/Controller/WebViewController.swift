//
//  WebViewController.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/10/29.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate: class {
    func webViewControllerDidClickSwitch(_ controller: WebViewController)
}

class WebViewController: UIViewController {
    
    weak var delegate: WebViewControllerDelegate?
    
    private var cancelBtn: UIButton?
    private var searchTF: UITextField!
    
    var searchBar: UISearchBar!
    
    //是否有加载页，默认没有，显示个人收藏页面
    private var haveLoadedPage: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //保证webview顶部和底部的正常布局
//        if #available(iOS 11.0, *) {
//            webView.scrollView.contentInsetAdjustmentBehavior = .never
//        } else {
//            automaticallyAdjustsScrollViewInsets = true
//            edgesForExtendedLayout = []
//        }
//        navigationController?.navigationBar.isTranslucent = false
        
        
        
        addSubViews()
        addObserveOnWebView()
        showPersonalView()
        configSearchBar()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configProgressView()
    }
    
    //顶部视图
    lazy var navView: NavigationView = {
        let frame = CGRect(x: 0, y: 0, width: kScreenW, height: navigationH)
        let it = NavigationView(frame: frame)
        return it
    }()
    
    //底部视图
    lazy var tabbarView: TabbarView = {
        let frame = CGRect(x: 0, y: kScreenH - tabbarH, width: kScreenW, height: tabbarH)
        let it = TabbarView(frame: frame)
        it.delegate = self
        return it
    }()
    
    //浏览器
    lazy var webView: WKWebView = {
        let frame = CGRect(x: 0, y: navigationH, width: kScreenW, height: kScreenH - navigationH)
        let it = WKWebView(frame: frame)
        it.navigationDelegate = self
        it.scrollView.delegate = self
        return it
    }()
    
    //进度条
    lazy var progressView: UIProgressView = {
        let it = UIProgressView()
        return it
    }()


    
    //收藏页
    private lazy var personalCollectionView: PersonalCollectionView = {
        let it = PersonalCollectionView()
        it.delegate = self
        it.dataSource = self
        return it
    }()
    
    private let searchImageView = UIImageView(image: UIImage(named: "searchbar_search"))
    private let lockImageView = UIImageView(image: UIImage(named: "searchbar_lock"))

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == estimatedProgressKeyPath {
            if let change = change, let progress = change[NSKeyValueChangeKey.newKey] as? Float {
                if progress >= progressView.progress {
                    progressView.setProgress(progress, animated: true)
                } else {
                    progressView.setProgress(progress, animated: false)
                }
                if progress >= 1 {
                    UIView.animate(withDuration: 0.35, delay: 0.15, options: .allowAnimatedContent, animations: {
                        self.progressView.alpha = 0
                    }) { (finished) in
                        if finished {
                            self.progressView.setProgress(0, animated: false)
                            self.progressView.alpha = 1
                        }
                    }
                }
            }
        }
        else if keyPath == canGoBackKey {
            tabbarView.backBtn.isEnabled = webView.canGoBack
        }
        else if keyPath == canGoForwardKey {
            tabbarView.forwardBtn.isEnabled = webView.canGoForward
        }
        else if keyPath == urlKey {
            progressView.setProgress(0.2, animated: true)
        }
        else if keyPath == hasOnlySecureContentKey {
            searchTF.leftView = webView.hasOnlySecureContent ? lockImageView : searchImageView
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finished")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
}


extension WebViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBar.setPositionAdjustment(UIOffset.zero, for: .search)
        
        if self.haveLoadedPage {
            searchTF.text = self.webView.url?.absoluteString
            showPersonalView()
        }

        return true
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
        
        DispatchQueue.main.async {
            self.searchTF.selectAll(nil)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if haveLoadedPage {
            searchBar.setPositionAdjustment(UIOffset(horizontal: calculateOffsetXOnSearchBar(from: webView.url!.host!), vertical: 0), for: .search)
            searchTF.text = webView.url?.host
            hidePersonalView()
        } else {
            let offSetX = calculateOffsetXOnSearchBar(from: searchBarDefaultHolder)
            searchBar.setPositionAdjustment(UIOffset(horizontal: offSetX, vertical: 0), for: .search)
            searchTF.text = ""
        }
        
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        haveLoadedPage = true
        urlRequestFromCurrentTextfield()
        hidePersonalView()
        
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        
        if let host = webView.url?.host {
            searchTF.text = host
            searchBar.setPositionAdjustment(UIOffset(horizontal: calculateOffsetXOnSearchBar(from: host), vertical: 0), for: .search)
        }
        
    }
}

extension WebViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        webView.loadURLString("https://m.hupu.com")
        haveLoadedPage = true
        hidePersonalView()
        
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        
        if let host = webView.url?.host {
            searchTF.text = host
            searchBar.setPositionAdjustment(UIOffset(horizontal: calculateOffsetXOnSearchBar(from: host), vertical: 0), for: .search)
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? collectionDataSource.count : commonDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonalCollectionCell.reuseIndentifier, for: indexPath) as! PersonalCollectionCell
        cell.model = indexPath.section == 0 ? collectionDataSource[indexPath.item] : commonDataSource[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PersonalCollectionHeaderView.reuseIndentifier, for: indexPath) as! PersonalCollectionHeaderView
        headerView.titleLabel.text = indexPath.section == 0 ? "个人收藏" : "经常访问的网站"
        return headerView
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            searchBar.isUserInteractionEnabled = false
        } else {
            searchBar.isUserInteractionEnabled = true
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if scrollView.contentOffset.y > 0 {
                searchBar.isUserInteractionEnabled = false
            } else {
                searchBar.isUserInteractionEnabled = true
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == personalCollectionView {
            if searchBar.isFirstResponder {
                searchBar.resignFirstResponder()
                setCancelBtnEnable()
            }
        } else if scrollView == webView.scrollView {
            if !haveLoadedPage { return }
            
            var offSetY = scrollView.contentOffset.y
            
            if offSetY == 0 { searchBar.isUserInteractionEnabled = true }
            
            if offSetY > differenceInNavigationH {
                offSetY = differenceInNavigationH
            } else if offSetY < 0 {
                offSetY = 0
            }
            
            //
            navView.frame.origin.y = -offSetY
            //
            webView.frame.origin.y = navigationH - offSetY
            webView.frame.size.height = kScreenH - navigationH + offSetY
            
            //0.75是searchBar的缩小比例
            let scale = 1 - (offSetY / differenceInNavigationH) * (1 - 0.75)
            searchBar.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            //10是searchTextField默认的frame.origin.y,  15为最大增量
            let translationY = 10 + (offSetY / differenceInNavigationH) * 15
            searchTF.frame.origin.y = translationY
            
            //searchTextField的背景颜色在(238,238,239)和(255,255,255)之间渐变
            let color = UIColor(r: 238 + (offSetY/differenceInNavigationH) * (255 - 238), g: 238 + (offSetY/differenceInNavigationH) * (255 - 238), b: 238 + (offSetY/differenceInNavigationH) * (255 - 239))
            searchTF.backgroundColor = color
            
            //改变tabbar的originY
            let tabbarOriginY = kScreenH  - ( 1 - offSetY / differenceInNavigationH) * tabbarH
            tabbarView.frame.origin.y = tabbarOriginY
                        
        }
    }
}

// MARK: - TabbarViewDelegate
extension WebViewController: TabbarViewDelegate {
    func tabbarViewDidClickBack(_ tabbarView: TabbarView) {
        if webView.canGoBack { webView.goBack() }
    }
    func tabbarViewDidClickForward(_ tabbarView: TabbarView) {
        if webView.canGoForward { webView.goForward() }
    }
    func tabbarViewDidClickShare(_ tabbarView: TabbarView) {
        print("share")
    }
    func tabbarViewDidClickMark(_ tabbarView: TabbarView) {
        print("mark")
    }
    func tabbarViewDidClickSwitch(_ tabbarView: TabbarView) {
        delegate?.webViewControllerDidClickSwitch(self)
    }
}


// MARK: - Helper
extension WebViewController {
    
    private func addSubViews() {
        view.addSubview(navView)
        view.addSubview(webView)
        view.addSubview(tabbarView)
    }
    
    //配置搜索框
    private func configSearchBar() {
        searchBar = navView.searchBar
        searchBar.delegate = self
        
        if #available(iOS 13.0, *) {
            searchTF = searchBar.searchTextField
        } else {
            if let view = searchBar.subviews.first, let tfClass = NSClassFromString("UISearchBarTextField") {
                for subView in view.subviews {
                    if subView.isKind(of: tfClass) {
                        searchTF = subView as? UITextField
                        break
                    }
                }
            }
        }
        searchTF.clearButtonMode = .whileEditing
        searchTF.leftView = searchImageView
        searchTF.attributedPlaceholder = defaultSearchHolder
    }

    
    //KVO观察webView的各个属性
    private func addObserveOnWebView() {
        webView.addObserver(self, forKeyPath: canGoBackKey, options: .new, context: nil)
        webView.addObserver(self, forKeyPath: canGoForwardKey, options: .new, context: nil)
        webView.addObserver(self, forKeyPath: estimatedProgressKeyPath, options: .new, context: nil)
        webView.addObserver(self, forKeyPath: urlKey, options: .new, context: nil)
        webView.addObserver(self, forKeyPath: hasOnlySecureContentKey, options: .new, context: nil)
    }
    
    //配置进度条
    private func configProgressView() {
        let tfFrame = searchTF.frame
        let frame = CGRect(x: 7, y: tfFrame.size.height - 2, width: tfFrame.size.width - 7 * 2, height: 2)
        progressView.frame = frame
        progressView.progressTintColor = kBtnAbledColor
        progressView.trackTintColor = .clear
        searchTF.addSubview(progressView)
    }
    
    //显示收藏页
    private func showPersonalView() {
        if personalCollectionView.superview == nil {
            view.addSubview(personalCollectionView)
        }
        UIView.animate(withDuration: 0.1) {
            self.personalCollectionView.alpha = 1
            self.personalCollectionView.transform = CGAffineTransform.identity
        }
    }
    
    //隐藏收藏页
    private func hidePersonalView() {
        UIView.animate(withDuration: 0.1) {
            self.personalCollectionView.alpha = 0
            self.personalCollectionView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    //请求当前输入的网址
    private func urlRequestFromCurrentTextfield() {
        if let text = searchTF.text, !text.isEmpty, let url = URL(string: text) {
            if !text.hasPrefix("http") {
                if let completelyUrl = URL(string: "https://" + text) {
                    let request = URLRequest(url: completelyUrl)
                    webView.load(request)
                }
            } else {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
    
    //根据Url是否是HTTPS，来决定是否显示`锁`
    private func changeUIWithHTTPS() {
        if let url = webView.url {
            if url.isHTTPS() {
                searchTF.leftView = lockImageView
            } else {
                searchTF.leftView = nil
            }
        }
    }
    
    //因为关闭键盘时，系统会使该按钮失效
    //因此拿到这个按钮，并阻止它失效
    private func setCancelBtnEnable() {
        if cancelBtn == nil {
            guard let buttonClass = NSClassFromString("UINavigationButton") else { return }

            for subview in searchBar.subviews[0].subviews[0].subviews {
                if subview.isKind(of: buttonClass) {
                    cancelBtn = (subview as! UIButton)
                    cancelBtn?.isEnabled = true
                    return
                }
            }
        } else {
            cancelBtn!.isEnabled = true
        }
    }
    
}


private extension URL {
    func isHTTPS()-> Bool {
        if absoluteString.count >= 8 {
            let prefix = self.absoluteString.substring(from: 0, to: 7)
            return prefix == "https://"
        }
        return false
    }
}

private let collectionDataSource: [PersonalModel] = [
    PersonalModel(name: "facebook", iconImageName: "logo_facebook"),
    PersonalModel(name: "instagram", iconImageName: "logo_instagram"),
    PersonalModel(name: "linkedin", iconImageName: "logo_linkedin"),
]

private let commonDataSource: [PersonalModel] = [
    PersonalModel(name: "html5", iconImageName: "logo_html5"),
    PersonalModel(name: "trello", iconImageName: "logo_trello"),
]

private let differenceInNavigationH: CGFloat = 32

private let estimatedProgressKeyPath = "estimatedProgress"
private let canGoBackKey = "canGoBack"
private let canGoForwardKey = "canGoForward"
private let urlKey = "URL"
private let hasOnlySecureContentKey = "hasOnlySecureContent"
private let defaultSearchHolder: NSAttributedString = NSAttributedString(string: searchBarDefaultHolder, attributes: [NSAttributedString.Key.foregroundColor: kTextGray])




//TODO:   webView的stopLoading配合导航上的 X 按钮。
