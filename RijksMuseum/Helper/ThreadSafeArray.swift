//
//  ThreadSafeArray.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/10/21.
//

import Foundation

public class ThreadSafeArray<T> {
    private var arrayQueue = DispatchQueue(label: "thread.safe.array.queue", attributes: .concurrent)
    private var array: [T]
    
    public init(with items: [T]) {
        array = items
    }
    
    public func append(with item: T) {
        arrayQueue.async(flags: .barrier) {
            self.array.append(item)
        }
    }
    
    public func removeAll() {
        arrayQueue.async(flags: .barrier) {
            self.array.removeAll()
        }
    }
    
    public var value: [T] {
        arrayQueue.sync() {
            return self.array
        }
    }
}
