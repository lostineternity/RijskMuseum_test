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
                DispatchQueue.main.async {
                    self.delegate?.failureFetching(with: error.errorDerscription)
                }
            case .success(let items):
                self.fillDataFromModel(with: items) {
                    self.currentPage += 1
                    DispatchQueue.main.async {
                        self.delegate?.successFetching(with: self.artObjects.value)
                    }
                }
            }
        }
    }

    private func fillDataFromModel(with collection: CollectionItems, completionHandler: @escaping ()->()) {
        for item in collection.artObjects {
            artObjects.append(with: ArtObjectPreview(title: item.longTitle,
                                                     backgroundImageUrl: item.headerImage.fittedToScreenSizeURL,
                                                     guid: item.objectNumber))
        }
        completionHandler()
    }
    
    func openDetailViewController(with itemId: String) {
        router.perfomAction(with: .openDetail(itemId))
    }
}
