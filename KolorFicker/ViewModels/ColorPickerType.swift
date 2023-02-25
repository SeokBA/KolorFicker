//
//  ColorPickerType.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/06/12.
//

import Foundation

enum ColorPickerType: String, CaseIterable {
    case hex = "HEX"
    case rgb = "RGB"
    case cmyk = "CMYK"
    case hsv = "HSV"
    case hsl = "HSL"
}

extension ColorPickerType {
    var title: String {
        rawValue
    }
}

extension ColorPickerType: Identifiable {
    var id: String {
        rawValue
    }
}
