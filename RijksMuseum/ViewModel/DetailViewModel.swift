//
//  DetailViewModel.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/12/21.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func fetchingProcessing()
    func successFetching(with item: DetailItem)
    func failureFetching(with errorDescription: String)
}

protocol DetailViewModel {
    var itemId: String { get }
    var delegate: DetailViewModelDelegate? { get set }
    var networkService: DetailNetworkService { get set }
    func fetchData()
}

final class DetailViewModelImpl: DetailViewModel {
    private (set) var itemId: String
    weak var delegate: DetailViewModelDelegate?
    var networkService: DetailNetworkService
    
    init(with itemId: String, networkService: DetailNetworkService) {
        self.itemId = itemId
        self.networkService = networkService
    }
    
    func fetchData() {
        delegate?.fetchingProcessing()
        networkService.fetchDetailItemData(with: itemId) { [weak self] response in
            guard let `self` = self else { return }
            switch response {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.failureFetching(with: error.errorDerscription)
                }
            case .success(let artObjectCover):
                self.fillDataFromModel(with: artObjectCover.artObject) { item in
                    DispatchQueue.main.async {
                        self.delegate?.successFetching(with: item)
                    }
                }
            }
        }
    }
    
    private func fillDataFromModel(with artObject: ArtObjectDetail, completionHandler: @escaping (DetailItem)->()) {
        var itemInfo = [ItemInfoSection]()
        var itemImage: Data? = nil
        
        // 1. General info
        var generalInfoItemSection = ItemInfoSection(sectionName: "General information", sectionInfo: [])
        generalInfoItemSection.sectionInfo.append(("Obj. number", artObject.objectNumber))
        generalInfoItemSection.sectionInfo.append(("Title", artObject.longTitle))
        if let subtitle = artObject.subTitle {
            generalInfoItemSection.sectionInfo.append(("Additional", subtitle))
        }
        itemInfo.append(generalInfoItemSection)
        
        // 2. Creation info
        var creationInfoSection = ItemInfoSection(sectionName: "Creation info", sectionInfo: [])
        if let creator = artObject.principalOrFirstMaker {
            creationInfoSection.sectionInfo.append(("Creator", creator))
        }
        if let period = artObject.dating.presentingDate {
            creationInfoSection.sectionInfo.append(("Estimate creation date", String(period)))
        }
        if artObject.objectTypes.count > 0 {
            creationInfoSection.sectionInfo.append(("Type", artObject.objectTypes.joined(separator: ", ")))
        }
        if artObject.materials.count > 0 {
            creationInfoSection.sectionInfo.append(("Materials", artObject.materials.joined(separator: ", ")))
        }
        if artObject.techniques.count > 0 {
            creationInfoSection.sectionInfo.append(("Techniques", artObject.techniques.joined(separator: ", ")))
        }
        if creationInfoSection.sectionInfo.count > 0 {
            itemInfo.append(creationInfoSection)
        }
        
        // 3. Acquisition
        if let acquisition = artObject.acquisition {
            var acquisitionInfoSection = ItemInfoSection(sectionName: "Acquisition info", sectionInfo: [])
            acquisitionInfoSection.sectionInfo.append(("Method", acquisition.method))
            if let creditLine = acquisition.creditLine {
                acquisitionInfoSection.sectionInfo.append(("Credit line", creditLine))
            }
            itemInfo.append(acquisitionInfoSection)
        }
        
        if let imageData = artObject.webImage, let fittedToScreenSizeURL = imageData.fittedToScreenSizeURL {
            networkService.loadItemHeaderImage(with: fittedToScreenSizeURL) { [weak self] response in
                switch response {
                case .success(let data):
                    itemImage = data
                    completionHandler(DetailItem(image: itemImage, itemInfo: itemInfo))
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.delegate?.failureFetching(with: error.errorDerscription)
                    }
                }
            }
        } else {
            completionHandler(DetailItem(image: nil, itemInfo: itemInfo))
        }
    }
}
