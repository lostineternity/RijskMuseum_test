//
//  SafeDecodable.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/11/21.
//

import Foundation

public struct Safe<Base: Decodable>: Decodable {
    public let value: Base?
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Base.self)
        } catch {
            print(error)
            self.value = nil
        }
    }
}
