//
//  PreviewCollectionItemCell.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/10/21.
//

import UIKit

class PreviewCollectionItemCell: UICollectionViewCell {
    
    var viewModel: PreviewItemCellViewModel? {
        didSet {
            fillViews()
        }
    }
 
    fileprivate let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DefaultImages.noPhoto.image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    fileprivate let previewTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: -1, height: 1)
        label.numberOfLines = 0
        return label
    }()
    
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
    
    public func configure(with viewModel: PreviewItemCellViewModel) {
        self.viewModel = viewModel
    }

    private func fillViews() {
        guard let viewModel = viewModel else {
            previewTitle.text = ""
            backgroundImage.image = DefaultImages.noPhoto.image
            return
        }
        previewTitle.text = viewModel.artObjectPreview.title
        viewModel.fetchImageData(completion: { [weak self] (imageData, itemGuid) in
            if viewModel.artObjectPreview.guid == itemGuid {
                self?.backgroundImage.image = UIImage(data: imageData)
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        viewModel = nil
    }
}
