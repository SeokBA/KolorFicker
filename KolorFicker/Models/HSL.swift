//
//  HSL.swift
//  KolorFicker
//
//  Created by tuna.can on 2023/03/26.
//

import Foundation

public struct HSL {
    @ColorProperty(max: 360) public var hue: Double
    @ColorProperty(max: 1) public var saturation: Double
    @ColorProperty(max: 1) public var lightness: Double
    
    public init(hue: Double, saturation: Double, lightness: Double) {
        self.hue = hue
        self.saturation = saturation
        self.lightness = lightness
    }
}
