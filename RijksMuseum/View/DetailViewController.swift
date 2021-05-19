//
//  DetailViewController.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/12/21.
//

import UIKit

fileprivate enum Size {
    static let contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    static let basicCellHeigt = CGFloat(40)
}

class DetailViewController: UIViewController, ActivityIndicatorPresenter {
    private var item: DetailItem? {
        didSet {
            fillViews()
        }
    }

    public var viewModel: DetailViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    private var elementWidth: CGFloat {
        CGFloat(view.safeAreaLayoutGuide.layoutFrame.width) - collectionView.contentInset.left - collectionView.contentInset.right
    }
    
    var activityIndicator = UIActivityIndicatorView()
   
    fileprivate var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .darkGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.register(DetailItemHeaderCollectionViewCell.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: DetailItemHeaderCollectionViewCell.identifier)
        collectionView.register(DetailItemCollectionViewCell.self,
                    forCellWithReuseIdentifier: DetailItemCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupImageView()
        setupCollectionView()
        loadData()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = Size.contentInset
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private func setupNavigationBar() {
        view.backgroundColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func fillViews() {
        if let imageData = item?.image, let image = UIImage(data: imageData) {
            imageView.image = image
        } else {
            imageView.image = DefaultImages.noPhoto.image
        }
    }
    
    private func loadData() {
        viewModel.fetchData()
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func successFetching(with item: DetailItem) {
        self.item = item
        collectionView.reloadData()
        hideActivityIndicator()
    }
    
    func failureFetching(with errorDescription: String) {
        showErrorAlert(message: errorDescription, actionHandler: { [weak self] in self?.navigationController?.popViewController(animated: true) })
        hideActivityIndicator()
    }
    
    func fetchingProcessing() {
        showActivityIndicator()
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: elementWidth, height: Size.basicCellHeigt)
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item?.itemInfo[section].sectionInfo.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return item?.itemInfo.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                withReuseIdentifier: DetailItemHeaderCollectionViewCell.identifier,
                                                                                for: indexPath) as? DetailItemHeaderCollectionViewCell {
                headerView.configure(with: item?.itemInfo[indexPath.section].sectionName ?? "")
                return headerView
            } else {
                return UICollectionReusableView()
            }
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailItemCollectionViewCell.identifier,
                                                                for: indexPath) as? DetailItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let cellData = item?.itemInfo[indexPath.section].sectionInfo[indexPath.item] {
            cell.configure(with: cellData.name, infoText: cellData.info, cellWidth: elementWidth)
        } else {
            cell.configure(with: "", infoText: "", cellWidth: elementWidth)
        }
        return cell
    }
}
