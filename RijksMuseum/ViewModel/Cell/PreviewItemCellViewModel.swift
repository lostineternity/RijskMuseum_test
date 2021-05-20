//
//  PreviewCollectionItemCellViewModel.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/19/21.
//

import Foundation

protocol PreviewItemCellViewModel {
    typealias CompletionHandler = (Data, String)->()
    var artObjectPreview: ArtObjectPreview { set get }
    var networkService: PreviewItemNetworkService { set get }
    func fetchImageData(completion: @escaping CompletionHandler)
}

final class PreviewItemCellViewModelImpl: PreviewItemCellViewModel {
    var networkService: PreviewItemNetworkService
    var artObjectPreview: ArtObjectPreview
    
    init(with item: ArtObjectPreview, networkService: PreviewItemNetworkService) {
        self.artObjectPreview = item
        self.networkService = networkService
    }
    
    func fetchImageData(completion: @escaping (Data, String) -> ()) {
        networkService.loadImageData(with: artObjectPreview.backgroundImageUrl) { [weak self] response in
            guard let `self` = self else { return }
            switch response {
            case .success(let imageData):
                DispatchQueue.main.async {
                    completion(imageData, self.artObjectPreview.guid)
                }
            case .failure:
                break
            }
        }
    }
}
