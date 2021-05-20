//
//  Settings.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/18/21.
//

import Foundation
import UIKit

public enum DefaultImages: String {
    case rijksmuseumLogo
    case noPhoto
    
    var image: UIImage {
        get {
            return UIImage(named: self.rawValue) ?? UIImage()
        }
    }
}

public enum URLs {
    static let requestBaseURL = "https://www.rijksmuseum.nl/api/"
}

public enum Keys {
    static let apiKey = "0fiuZFh4"
}

public enum PreviewDataSettings {
    static let urlPath = "collection"
    static let itemsPerPage = "10"
    static let culture = "en"
    static let format = "json"
}

public enum ScreenProperties {
    static var screenWidth: Int {
        Int(UIScreen.main.bounds.width)
    }
    static var screenHeight: Int {
        Int(UIScreen.main.bounds.height)
    }
}
