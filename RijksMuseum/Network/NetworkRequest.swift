//
//  NetworkRequest.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/11/21.
//

import Foundation

protocol NetworkRequest {
    var urlPath: String { get }
    var parameters: [URLQueryItem] { get set }
}
