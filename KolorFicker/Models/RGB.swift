//
//  RGB.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/08/16.
//

import Foundation

public struct RGB: ColorConvertable {
    @ColorProperty(max: 255) public var red: Double
    @ColorProperty(max: 255) public var green: Double
    @ColorProperty(max: 255) public var blue: Double
    
    public init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}

public extension RGB {
    var convertedToHex: HEX {
        convertedToHex(from: self)
    }
    
    var convertedToCMYK: CMYK {
        convertedToCMYK(from: self)
    }
    
    var convertedToHSV: HSV {
        convertedToHSV(from: self)
    }
    
    var convertedToHSL: HSL {
        convertedToHSL(from: self)
    }
}
