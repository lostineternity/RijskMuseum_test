//
//  DetailItemHeaderCollectionViewCell.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/12/21.
//

import UIKit

class DetailItemHeaderCollectionViewCell: UICollectionViewCell {
    fileprivate let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: -1, height: 1)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(title)
        title.makeZeroConstraints(to: contentView)
    }
    
    public func configure(with sectiolTitle: String) {
        title.text = sectiolTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

