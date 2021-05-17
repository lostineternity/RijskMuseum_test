//
//  PreviewNetworkRequest.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/11/21.
//

import Foundation

struct PreviewNetworkRequest: NetworkRequest {
    var urlPath: String
    var parameters: [URLQueryItem] = []

    init(page: Int) {
        parameters.append(URLQueryItem(name: "format", value: PreviewDataSettings.format))
        parameters.append(URLQueryItem(name: "ps", value: PreviewDataSettings.itemsPerPage))
        parameters.append(URLQueryItem(name: "p", value: String(page)))
        parameters.append(URLQueryItem(name: "key", value: Keys.apiKey))
        urlPath = "/api/\(PreviewDataSettings.culture)/\(PreviewDataSettings.urlPath)"
    }
}
