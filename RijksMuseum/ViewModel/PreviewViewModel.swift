//
//  CollectionViewModel.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/11/21.
//

import Foundation

protocol PreviewViewModelDelegate: AnyObject {
    func fetchingProcessing()
    func successFetching(with items: [ArtObjectPreview])
    func failureFetching(with errorDescription: String)
}

protocol PreviewViewModel {
    var router: PreviewRouter { get set }
    var delegate: PreviewViewModelDelegate? { set get }
    var networkService: PreviewNetworkService { set get }
    func openDetailViewController(with itemId: String)
    func fetchData(page: Int?)
}

final class PreviewViewModelImpl: PreviewViewModel {
    private var artObjects = ThreadSafeArray(with: [ArtObjectPreview]())
   
    private (set) var isFetching = false
    private (set) var currentPage = 1
    
    var router: PreviewRouter
    var networkService: PreviewNetworkService
    weak var delegate: PreviewViewModelDelegate?
    
    init(with networkService: PreviewNetworkService, router: PreviewRouter) {
        self.router = router
        self.networkService = networkService
    }
    
    func fetchData(page: Int?) {
        if isFetching { return }
        isFetching = true
        if let pageToFetch = page {
            currentPage = pageToFetch
            if currentPage == 1 {
                artObjects.removeAll()
            }
        } else {
            delegate?.fetchingProcessing()
        }
        networkService.fetchCollectionData(page: currentPage) { [weak self] response in
            guard let `self` = self else { return }
            self.isFetching = false
            switch response {
            case .failure(let error):
                self.delegate?.failureFetching(with: error.errorDerscription)
            case .success(let items):
                self.fillDataFromModel(with: items) {
                    self.currentPage += 1
                    self.delegate?.successFetching(with: self.artObjects.value)
                }
            }
        }
    }

    private func fillDataFromModel(with collection: CollectionItems, completionHandler: @escaping ()->()) {
        let loadingDispatchGroup = DispatchGroup()
        for item in collection.artObjects {
            loadingDispatchGroup.enter()
            networkService.loadItemHeaderImage(with: item.headerImage.fittedToScreenSizeURL) { [weak self] response in
                guard let `self` = self else { return }
                switch response {
                    case .success(let imageData):
                        self.artObjects.append(with: ArtObjectPreview(title: item.longTitle,
                                                                          backgroundImage: imageData,
                                                                          guid: item.objectNumber))
                    case .failure(let error):
                        print(error.errorDerscription)
                }
                loadingDispatchGroup.leave()
            }
        }
        loadingDispatchGroup.notify(queue: .main) {
            completionHandler()
        }
    }
    
    func openDetailViewController(with itemId: String) {
        router.perfomAction(with: .openDetail(itemId))
    }
}
