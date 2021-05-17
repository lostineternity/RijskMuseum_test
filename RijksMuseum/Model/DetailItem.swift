//
//  DetailItem.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/12/21.
//

import Foundation

public struct DetailItem {
    let image: Data?
    let itemInfo: [ItemInfoSection]
}

public struct ItemInfoSection {
    typealias ItemInfo = (name: String, info: String)
    var sectionName: String
    var sectionInfo: [ItemInfo]
}
