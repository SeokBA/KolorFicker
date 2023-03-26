//
//  CMYK.swift
//  KolorFicker
//
//  Created by tuna.can on 2023/03/26.
//

import Foundation

public struct CMYK: ColorConvertable {
    @ColorProperty(max: 100) public var cyan: Double
    @ColorProperty(max: 100) public var magenta: Double
    @ColorProperty(max: 100) public var yellow: Double
    @ColorProperty(max: 100) public var black: Double
    
    public init(cyan: Double,
                magenta: Double,
                yellow: Double,
                black: Double)
    {
        self.cyan = cyan
        self.magenta = magenta
        self.yellow = yellow
        self.black = black
    }
}

public extension CMYK {
    var convertedToRGB: RGB {
        convertedToRGB(from: self)
    }
}
