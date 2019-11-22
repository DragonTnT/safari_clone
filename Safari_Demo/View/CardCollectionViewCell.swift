//
//  CardCollectionViewCell.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/11/19.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit

protocol CardCollectionViewCellDelegate: class {
    func cardCollectionViewCellCloseButtonTapped(_ cell: CardCollectionViewCell)
}

class CardCollectionViewCell: UICollectionViewCell {
    static let reuseIndentifier = "CardCollectionViewCell"
    
    private var defaultCornerRadius: CGFloat = 8
        
    weak var delegate: CardCollectionViewCellDelegate?
    
    var title: String? {
        didSet {
            headerView.titleLabel.text = title
        }
    }
    var snapshot: UIImage? {
        didSet {
            snapshotContainer.image = snapshot
        }
    }
    
    private let headerView: CardCollectionViewCell.HeaderView
    var headerViewHeightAnchor: NSLayoutConstraint!
    var snapShotTopAnchor: NSLayoutConstraint!
    private let snapshotContainer: UIImageView
    let gradientLayer: CAGradientLayer
    
    override init(frame: CGRect) {
        headerView = CardCollectionViewCell.HeaderView()
        snapshotContainer = UIImageView()
        gradientLayer = CAGradientLayer()
        super.init(frame: frame)
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale

        self.contentView.layer.cornerRadius = defaultCornerRadius
        self.contentView.layer.masksToBounds = true
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = UIColor.white.withAlphaComponent(0)
        self.backgroundView?.layer.cornerRadius = defaultCornerRadius
        self.backgroundView?.layer.masksToBounds = true

        let contentView = self.contentView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        snapshotContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerView)
        contentView.addSubview(snapshotContainer)
        
        headerView.backgroundColor = .white
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.init(white: 0, alpha: 0.4).cgColor, UIColor.init(white: 0, alpha: 0.6).cgColor]
        gradientLayer.locations = [0, 0.4, 1]
//        self.snapshotContainer.layer.addSublayer(gradientLayer)
        self.contentView.backgroundColor = .black
        
        headerView.closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        headerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        headerViewHeightAnchor = headerView.heightAnchor.constraint(equalToConstant: 25)
        headerViewHeightAnchor.isActive = true
        
        snapshotContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        snapshotContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        snapshotContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        snapShotTopAnchor = snapshotContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25)
        snapShotTopAnchor.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.snapshotContainer.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        title = nil
        snapshot = nil
    }
    
    func showHeaderView() {
        headerViewHeightAnchor.constant = 25
        snapShotTopAnchor.constant = 25
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    
    func hideHeaderView() {
        headerViewHeightAnchor.constant = 0
        snapShotTopAnchor.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    
    
    @objc private func closeTapped() {
        delegate?.cardCollectionViewCellCloseButtonTapped(self)
    }
    
    class HeaderView: UIView {
        let closeButton: UIButton
        let titleLabel: UILabel
        
        init() {
            closeButton = UIButton(type: .system)
            titleLabel = UILabel()
            super.init(frame: .zero)
            
            closeButton.setImage(HeaderView.closeImage, for: .normal)
            closeButton.tintColor = .black
            
            titleLabel.text = ""
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(closeButton)
            addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
                closeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                closeButton.topAnchor.constraint(equalTo: topAnchor),
                closeButton.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        private static var closeImage: UIImage = {
            return UIGraphicsImageRenderer(size: CGSize(width: 12, height: 12)).image(actions: { context in
                let downwards = UIBezierPath()
                downwards.move(to: CGPoint(x: 1, y: 1))
                downwards.addLine(to: CGPoint(x: 11, y: 11))
                UIColor.black.setStroke()
                downwards.lineWidth = 2
                downwards.stroke()
                
                let upwards = UIBezierPath()
                upwards.move(to: CGPoint(x: 1, y: 11))
                upwards.addLine(to: CGPoint(x: 11, y: 1))
                UIColor.black.setStroke()
                upwards.lineWidth = 2
                upwards.stroke()
                
                context.cgContext.addPath(downwards.cgPath)
                context.cgContext.addPath(upwards.cgPath)
            })
        }()
    }
}
