//
//  PersonalCollectionCell.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/10/31.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit

class PersonalCollectionCell: UICollectionViewCell {
    
    static let reuseIndentifier = "PersonalCollectionCell"

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    var model: PersonalModel! {
        didSet {
            iconImageView.image = UIImage(named: model.iconImageName)
            nameLabel.text = model.name
        }
    }

}
