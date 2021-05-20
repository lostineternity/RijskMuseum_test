//
//  PreviewCollectionViewController.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/10/21.
//

import UIKit

fileprivate enum Size {
    static let contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    static let navigationBarViewFrame = CGRect(x: 0, y: 0, width: 160, height: 19)
    static let scrollDistanceToPrefetch = CGFloat(100)
    static let basicCellHeigt = CGFloat(120)
}

class PreviewCollectionViewController: UIViewController, ActivityIndicatorPresenter {
    public var viewModel: PreviewViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    private var elementWidth: CGFloat {
        CGFloat(view.safeAreaLayoutGuide.layoutFrame.width) - (Size.contentInset.left + Size.contentInset.right)
    }
    
    var activityIndicator = UIActivityIndicatorView()
    
    private var collectionItems: [ArtObjectPreview] = []
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .darkGray
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.tintColor = .white
        collectionView.refreshControl?.center = collectionView.center
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.register(PreviewCollectionItemCell.self, forCellWithReuseIdentifier: PreviewCollectionItemCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        loadData()
    }
    
    private func loadData() {
        viewModel.fetchData(page: 1)
    }
    
    private func setupNavigationBar() {
        let frame = Size.navigationBarViewFrame
        let containingView = UIView(frame: frame)
        let imageView = UIImageView(frame: frame)
        imageView.tintColor = .white
        imageView.image = DefaultImages.rijksmuseumLogo.image
        imageView.contentMode = .scaleAspectFit
        containingView.addSubview(imageView)
        navigationItem.titleView = containingView
        view.backgroundColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl?.addTarget(self, action: #selector(fetchFirstPage), for: .valueChanged)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = Size.contentInset
        }

        view.addSubview(collectionView)
        collectionView.makeZeroConstraints(to: view.safeAreaLayoutGuide)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc private func fetchFirstPage() {
        viewModel.fetchData(page: 1)
    }
}

extension PreviewCollectionViewController: PreviewViewModelDelegate {
    func successFetching(with items: [ArtObjectPreview]) {
        collectionItems = items
        collectionView.reloadData()
        collectionView.refreshControl?.endRefreshing()
        hideActivityIndicator()
    }
    
    func failureFetching(with errorDescription: String) {
        showErrorAlert(message: errorDescription)
        collectionView.refreshControl?.endRefreshing()
        hideActivityIndicator()
    }
    
    func fetchingProcessing() {
        showActivityIndicator()
    }
}

extension PreviewCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: elementWidth, height: Size.basicCellHeigt)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = collectionView.contentOffset.y
        if contentOffsetY > (collectionView.contentSize.height - collectionView.frame.size.height - Size.scrollDistanceToPrefetch ) {
            viewModel.fetchData(page: nil)
        }
    }
}

extension PreviewCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItemId = collectionItems[indexPath.item].guid
        viewModel.openDetailViewController(with: selectedItemId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCollectionItemCell.identifier, for: indexPath) as? PreviewCollectionItemCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: PreviewItemCellViewModelImpl(with: collectionItems[indexPath.item],
                                                          networkService: PreviewItemNetworkServiceImpl(requestService: RequestServiceImpl())))
        return cell
    }
}
