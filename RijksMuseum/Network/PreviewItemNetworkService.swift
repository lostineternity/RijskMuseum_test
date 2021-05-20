//
//  PreviewItemNetworkService.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/19/21.
//

import Foundation

protocol PreviewItemNetworkService {
    typealias ImageCompletionHandler = (Result<Data, NetworkError>)->()
    func loadImageData(with urlString: String, completionHandler: @escaping ImageCompletionHandler)
    var requestService: RequestService { get set }
}

struct PreviewItemNetworkServiceImpl: PreviewItemNetworkService {    
    var requestService: RequestService
    
    func loadImageData(with urlString: String, completionHandler: @escaping ImageCompletionHandler) {
        requestService.performRequest(with: urlString) { response in
            completionHandler(response)
        }
    }
}
