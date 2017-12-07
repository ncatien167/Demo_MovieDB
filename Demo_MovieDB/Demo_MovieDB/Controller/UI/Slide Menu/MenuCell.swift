//
//  MenuCell.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/7/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rpb(red: 0, green: 186, blue: 185)
        label.font = UIFont(name: "Avenir-Medium", size: 20)
        return label
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    override var isHighlighted: Bool {
        didSet {
            titleLabel.textColor = isHighlighted ? UIColor.white : UIColor.rpb(red: 0, green: 186, blue: 185)
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rpb(red: 0, green: 186, blue: 185)
        }
    }

    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? UIColor.white : UIColor.rpb(red: 0, green: 186, blue: 185)
            imageView.tintColor = isSelected ? UIColor.white : UIColor.rpb(red: 0, green: 186, blue: 185)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(bottomLineView)
        
        addContrainsWithFormat("H:|-20-[v0(25)]-20-[v1]|", view: imageView, titleLabel)
        addContrainsWithFormat("V:|[v0]|", view: titleLabel)
        addContrainsWithFormat("V:[v0(25)]", view: imageView)
        addContrainsWithFormat("V:[v0(0.5)]|", view: bottomLineView)
        addContrainsWithFormat("H:|[v0]|", view: bottomLineView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
