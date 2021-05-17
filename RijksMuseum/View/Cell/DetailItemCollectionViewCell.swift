//
//  DetailItemCollectionViewCell.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/12/21.
//

import UIKit

class DetailItemCollectionViewCell: UICollectionViewCell {
    fileprivate let title: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.lineBreakMode = .byWordWrapping
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.textColor = .lightGray
        $0.shadowColor = .black
        $0.shadowOffset = CGSize(width: -1, height: 1)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    fileprivate let info: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.lineBreakMode = .byWordWrapping
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .lightText
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    fileprivate var stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        return $0
    }(UIStackView())
    
    private var estimatedWidth: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(info)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        contentView.addSubview(stackView)
        stackView.makeZeroConstraints(to: contentView)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let targetSize = CGSize(width: estimatedWidth, height: 0)

        let autoLayoutSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        let autoLayoutFrame = CGRect(origin: autoLayoutAttributes.frame.origin, size: autoLayoutSize)

        autoLayoutAttributes.frame = autoLayoutFrame
        return autoLayoutAttributes
    }
    
    public func configure(with titleText: String, infoText: String, cellWidth: CGFloat) {
        estimatedWidth = cellWidth
        title.text = titleText
        info.text = infoText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
