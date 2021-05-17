//
//  DetailNetworkServiceImpl.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/12/21.
//

import Foundation

protocol DetailNetworkService {
    typealias DetailItemComletionHandler = (Result<ArtObjectDetailCover, NetworkError>)->()
    typealias DetailItemImageComletionHandler = (Result<Data, NetworkError>)->()
    func fetchDetailItemData(with itemId: String, completionHandler: @escaping DetailItemComletionHandler)
    func loadItemHeaderImage(with urlString: String, completionHandler: @escaping DetailItemImageComletionHandler)
    var requestService: RequestService { get set }
}

struct DetailNetworkServiceImpl: DetailNetworkService {
    var requestService: RequestService
    
    func loadItemHeaderImage(with urlString: String, completionHandler: @escaping DetailItemImageComletionHandler) {
        requestService.performRequest(with: urlString) { response in
            completionHandler(response)
        }
    }
    
    func fetchDetailItemData(with itemId: String, completionHandler: @escaping DetailItemComletionHandler) {
        requestService.performRequest(with: DetailNetworkRequest(itemId: itemId)) { response in
            completionHandler(response)
        }
    }
}
