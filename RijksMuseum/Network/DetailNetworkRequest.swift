//
//  DetailNetworkRequest.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/9/21.
//

import Foundation

struct DetailNetworkRequest: NetworkRequest {
    var urlPath: String
    var parameters: [URLQueryItem] = []

    init(itemId: String) {
        parameters.append(URLQueryItem(name: "format", value: PreviewDataSettings.format))
        parameters.append(URLQueryItem(name: "key", value: Keys.apiKey))
        urlPath = "/api/\(PreviewDataSettings.culture)/\(PreviewDataSettings.urlPath)/\(itemId)"
    }
}

