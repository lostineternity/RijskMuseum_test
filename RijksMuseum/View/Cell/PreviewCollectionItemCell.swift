//
//  PreviewCollectionItemCell.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/10/21.
//

import UIKit

class PreviewCollectionItemCell: UICollectionViewCell {
    var item: ArtObjectPreview? {
        didSet {
            fillViews()
        }
    }
    
    fileprivate let backgroundImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        return $0
    }(UIImageView())
    
    fileprivate let previewTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.lineBreakMode = .byWordWrapping
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .white
        $0.shadowColor = .black
        $0.shadowOffset = CGSize(width: -1, height: 1)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundImage)
        contentView.addSubview(previewTitle)
        
        backgroundImage.makeZeroConstraints(to: contentView)
        
        NSLayoutConstraint.activate([
            previewTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            previewTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            previewTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            previewTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
    }
    
    public func configure(with item: ArtObjectPreview?) {
        if self.item == item { return }
        self.item = item
    }

    private func fillViews() {
        if let item = item {
            backgroundImage.image = UIImage(data: item.backgroundImage)
            previewTitle.text = item.title
        } else {
            backgroundImage.image = UIImage()
            previewTitle.text = ""
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        item = nil
    }
}
