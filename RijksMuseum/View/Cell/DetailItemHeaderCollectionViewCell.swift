//
//  DetailItemHeaderCollectionViewCell.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/12/21.
//

import UIKit

class DetailItemHeaderCollectionViewCell: UICollectionViewCell {
    fileprivate let title: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.lineBreakMode = .byWordWrapping
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .white
        $0.shadowColor = .black
        $0.shadowOffset = CGSize(width: -1, height: 1)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
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

