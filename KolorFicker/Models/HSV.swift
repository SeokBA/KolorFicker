//
//  HSV.swift
//  KolorFicker
//
//  Created by tuna.can on 2023/03/26.
//

import Foundation

public struct HSV {
    @ColorProperty(max: 360) public var hue: Double
    @ColorProperty(max: 1) public var saturation: Double
    @ColorProperty(max: 1) public var value: Double
    
    public init(hue: Double, saturation: Double, value: Double) {
        self.hue = hue
        self.saturation = saturation
        self.value = value
    }
}
