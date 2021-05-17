//
//  NetworkService.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/11/21.
//

import Foundation

protocol RequestService {
    func performRequest<T: Codable>(with request: NetworkRequest, completionHandler: @escaping (Result<T, NetworkError>)->())
    func performRequest(with urlString: String, completionHandler: @escaping (Result<Data, NetworkError>)->())
}
