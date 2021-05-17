//
//  NetworkDataModel.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/10/21.
//

import Foundation

public struct CollectionItems: Codable {
    let count: Int
    let artObjects: [ArtObjectShort]
}

public struct ArtObjectShort: Codable {
    let objectNumber: String
    let title: String
    let longTitle: String
    let headerImage: ImageRaw
}

public struct ArtObjectDetailCover: Codable {
    let artObject: ArtObjectDetail
}

public struct ArtObjectDetail: Codable {
    let acquisition: Acquisition?
    let objectNumber: String
    let dating: Dating
    let materials: [String]
    let objectTypes: [String]
    let principalOrFirstMaker: String?
    let subTitle: String?
    let techniques: [String]
    let longTitle: String
    let webImage: ImageRaw?
}

struct Dating: Codable {
    let period: Int?
    let presentingDate: String?
}

public struct Acquisition: Codable {
    let method: String
    let creditLine: String?
}

public struct ImageRaw: Codable {
    let url: String
    var fittedToScreenSizeURL: String {
        url.replacingOccurrences(of: "=s0", with: "=w\(ScreenProperties.screenWidth)")
    }
}

