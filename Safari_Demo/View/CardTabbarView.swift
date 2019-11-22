//
//  CardTabbarView.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/11/20.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit

protocol CardTabbarViewDelegate: class {
    func cardTabbarViewDidClickAdd(_ tabbarView: CardTabbarView)
    func cardTabbarViewDidClickFinish(_ tabbarView: CardTabbarView)
}

class CardTabbarView: UIVisualEffectView {
    
    weak var delegate: CardTabbarViewDelegate?

    init() {
        let effect = UIBlurEffect(style: .dark)
        super.init(effect: effect)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        let addBtn = UIButton(type: .custom)
        addBtn.frame = CGRect(x: (kScreenW - 30)/2.0, y: 9.5, width: 30, height: 30)
        addBtn.setImage(#imageLiteral(resourceName: "tabbar_add"), for: .normal)
        addBtn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        contentView.addSubview(addBtn)
        
        let finishBtn = UIButton(type: .custom)
        finishBtn.frame = CGRect(x: kScreenW - 50, y: 9.5, width: 40, height: 30)
        finishBtn.setTitle("完成", for: .normal)
        finishBtn.addTarget(self, action: #selector(finishAction), for: .touchUpInside)
        contentView.addSubview(finishBtn)
    }
    
    func show() {
        UIView.animate(withDuration: 0.3) {
            self.frame.origin.y = kScreenH - tabbarH
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.frame.origin.y = kScreenH
        }
    }
    
    @objc private func addAction() {
        delegate?.cardTabbarViewDidClickAdd(self)
    }
    
    @objc private func finishAction() {
        hide()
        delegate?.cardTabbarViewDidClickFinish(self)
    }
}
