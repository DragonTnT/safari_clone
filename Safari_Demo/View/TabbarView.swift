//
//  TabbarView.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/10/29.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit

protocol TabbarViewDelegate: class {
    func tabbarViewDidClickBack(_ tabbarView: TabbarView)
    func tabbarViewDidClickForward(_ tabbarView: TabbarView)
    func tabbarViewDidClickShare(_ tabbarView: TabbarView)
    func tabbarViewDidClickMark(_ tabbarView: TabbarView)
    func tabbarViewDidClickSwitch(_ tabbarView: TabbarView)
}

class TabbarView: UIView {
    
    let backBtn: UIButton = UIButton(type: .custom)      //后退
    var forwardBtn: UIButton = UIButton(type: .custom)   //前进
    var shareBtn: UIButton = UIButton(type: .custom)     //分享
    var markBtn: UIButton = UIButton(type: .custom)      //书签
    var switchBtn: UIButton = UIButton(type: .custom)      //编辑
    
    weak var delegate: TabbarViewDelegate?
    
    override init(frame: CGRect) {        
        super.init(frame: frame)
        setupUI()
        addSubViews()
        configBtnStatus()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(r: 251, g: 251, b: 252)
    }
    
    private func addSubViews() {
        addSubview(backBtn)
        addSubview(forwardBtn)
        addSubview(shareBtn)
        addSubview(markBtn)
        addSubview(switchBtn)
        
        //最左边按钮
        backBtn.frame = CGRect(x: backBtnLeftMargin, y: backBtnTopMargin, width: btnLength, height: btnLength)
        //最右边按钮
        switchBtn.frame = CGRect(x: kScreenW - backBtnLeftMargin - btnLength, y: backBtnTopMargin, width: btnLength, height: btnLength)
        
        //中间3个按钮的边距是由屏幕宽度减去左右两个按钮的边距和宽度，再除以4
        let middleBtnMargin: CGFloat = (kScreenW - 2 * (btnLength + backBtnLeftMargin) - btnLength * 3)/4.0
        
        forwardBtn.frame = CGRect(x: backBtn.frame.origin.x + backBtn.frame.size.width + middleBtnMargin, y: backBtnTopMargin, width: btnLength, height: btnLength)
        
        shareBtn.frame = CGRect(x: forwardBtn.frame.origin.x + forwardBtn.frame.size.width + middleBtnMargin, y: backBtnTopMargin, width: btnLength, height: btnLength)
        
        markBtn.frame = CGRect(x: shareBtn.frame.origin.x + shareBtn.frame.size.width + middleBtnMargin, y: backBtnTopMargin, width: btnLength, height: btnLength)
        

        backBtn.setImage(forNormal: "tabbar_back_normal", forDisabled: "tabbar_back_disabled")
        
        forwardBtn.setImage(forNormal: "tabbar_forward_normal", forDisabled: "tabbar_forward_disabled")
        
        shareBtn.setImage(forNormal: "tabbar_share_normal", forDisabled: "tabbar_share_disabled")
        
        markBtn.setImage(forNormal: "tabbar_mark_normal", forDisabled: "tabbar_mark_disabled")
        
        switchBtn.setImage(UIImage(named: "tabbar_switch_normal"), for: .normal)
        
        backBtn.addTarget(self, action: #selector(didClickBtn(_:)), for: .touchUpInside)
        forwardBtn.addTarget(self, action: #selector(didClickBtn(_:)), for: .touchUpInside)
        shareBtn.addTarget(self, action: #selector(didClickBtn(_:)), for: .touchUpInside)
        markBtn.addTarget(self, action: #selector(didClickBtn(_:)), for: .touchUpInside)
        switchBtn.addTarget(self, action: #selector(didClickBtn(_:)), for: .touchUpInside)
        
    }
    
    private func configBtnStatus() {
        backBtn.isEnabled = false
        forwardBtn.isEnabled = false
    }
    
    @objc private func didClickBtn(_ btn: UIButton) {
        switch btn {
        case backBtn:
            delegate?.tabbarViewDidClickBack(self)
        case forwardBtn:
            delegate?.tabbarViewDidClickForward(self)
        case shareBtn:
            delegate?.tabbarViewDidClickShare(self)
            case markBtn:
            delegate?.tabbarViewDidClickMark(self)
            case switchBtn:
            delegate?.tabbarViewDidClickSwitch(self)
        default:
            return
        }
    }
}

fileprivate extension UIButton {
    func setImage(forNormal: String, forDisabled: String) {
        setImage(UIImage(named: forNormal), for: .normal)
        setImage(UIImage(named: forDisabled), for: .disabled)
    }
}


fileprivate let backBtnTopMargin: CGFloat = 10
fileprivate let backBtnLeftMargin: CGFloat = 20
fileprivate let btnLength: CGFloat = 33
