//
//  PreviewNetworkService.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/11/21.
//

import Foundation

protocol PreviewNetworkService {
    typealias PreviewCompletionHandler = (Result<CollectionItems, NetworkError>)->()
    typealias ImageCompletionHandler = (Result<Data, NetworkError>)->()
    func fetchCollectionData(page: Int, completionHandler: @escaping PreviewCompletionHandler)
    func loadItemHeaderImage(with urlString: String, completionHandler: @escaping ImageCompletionHandler)
    var requestService: RequestService { get set }
}

struct PreviewNetworkServiceImpl: PreviewNetworkService {
    var requestService: RequestService
    
    func fetchCollectionData(page: Int, completionHandler: @escaping PreviewCompletionHandler) {
        requestService.performRequest(with: PreviewNetworkRequest(page: page)) { response in
            completionHandler(response)
        }
    }
    
    func loadItemHeaderImage(with urlString: String, completionHandler: @escaping ImageCompletionHandler) {
        requestService.performRequest(with: urlString) { response in
            completionHandler(response)
        }
    }
}

