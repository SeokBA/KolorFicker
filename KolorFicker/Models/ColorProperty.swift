//
//  ColorProperty.swift
//  KolorFicker
//
//  Created by tuna.can on 2023/03/26.
//

import Foundation

@propertyWrapper
public struct ColorProperty<T: Numeric & Comparable> {
    private let maxValue: T
    private var value: T
    
    public var wrappedValue: T {
        get { value }
        set { value = min(newValue, maxValue) }
    }
    
    public init(initialValue: T = 0,
                max maxValue: T)
    {
        self.value = min(initialValue, maxValue)
        self.maxValue = maxValue
    }
}
