//
//  NetworkError.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/11/21.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case loadingError(String?)
    case serverSideError(String)
    case URLError
    case unknown
    
    var errorDerscription: String {
        switch self {
        case .decodingError: return String.decodingErrorText
        case .loadingError(let errorDescription):
            if let errorDescription = errorDescription {
                return "\(String.loadingErrorText): \(errorDescription)"
            } else {
                return String.loadingErrorText
            }
        case .serverSideError(let errorDescription): return "\(String.serverSideError): \(errorDescription)"
        case .unknown: return String.unknownErrorText
        case .URLError: return String.URLErrorText
        }
    }
}

fileprivate extension String {
    static let decodingErrorText = "Error occured during data decoding process"
    static let loadingErrorText = "Error occured during loading data from server"
    static let serverSideError = "Server side error occured"
    static let URLErrorText = "Unknown or wrong URL"
    static let unknownErrorText = "Unknown error"
}
