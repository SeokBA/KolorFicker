//
//  ColorPickerInteractor.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/06/12.
//

import Foundation

enum ColorPickerError: Error {
    case notConvertedToHue
}

protocol ColorPickerInteractorProtocol {
    func inputColorValue(value: String, type: ColorPickerType)
    func inputColorValue(red: Double, green: Double, blue: Double)
    func inputPickerColorSpace(_ colorSpace: PickerColorSpace)
}

final class ColorPickerInteractor {
    private let appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
}

extension ColorPickerInteractor: ColorPickerInteractorProtocol {
    func inputColorValue(value: String, type: ColorPickerType) {
        guard appState.colorPicker.currentColorString[type] != value,
              let rgbColorValue = makeRGBColorValue(value: value, type: type) else { return }
        setColorValue(rgbColorValue, inputedValue: value, editedType: type)
    }
    
    func inputColorValue(red: Double, green: Double, blue: Double) {
        setColorValue(RGB(red: red, green: green, blue: blue))
    }
    
    func inputPickerColorSpace(_ colorSpace: PickerColorSpace) {
        appState.colorPicker.currentPickerColorSpace = colorSpace
    }
}

private extension ColorPickerInteractor {
    func makeRGBColorValue(value: String, type: ColorPickerType) -> RGB? {
        switch type {
        case .hex:
            guard let hexStringValue = value.regexMatch(regex: "[a-fA-F0-9]{6}").first,
                  let hexValue = Int(hexStringValue, radix: 16) else { return nil }
            return RGB(red: Double((hexValue >> 16) & 0xFF),
                       green: Double((hexValue >> 8) & 0xFF),
                       blue: Double(hexValue & 0xFF))
        case .rgb:
            let extractedNumbers = extractNumbers(value)
            guard extractedNumbers.count == 3 else { return nil }
            return RGB(red: min(extractedNumbers[0], 255),
                       green: min(extractedNumbers[1], 255),
                       blue: min(extractedNumbers[2], 255))
        case .cmyk:
            let extractedNumbers = extractNumbers(value)
            guard extractedNumbers.count == 4 else { return nil }
            return CMYK(cyan: min(extractedNumbers[0], 100),
                        magenta: min(extractedNumbers[1], 100),
                        yellow: min(extractedNumbers[2], 100),
                        black: min(extractedNumbers[3], 100)).convertedToRGB
            
        case .hsv:
            let extractedNumbers = extractNumbers(value)
            guard extractedNumbers.count == 3 else { return nil }
            return HSV(hue: min(extractedNumbers[0], 360),
                       saturation: min(extractedNumbers[1], 100) / 100,
                       value: min(extractedNumbers[2], 100) / 100).convertedToRGB
            
        case .hsl:
            let extractedNumbers = extractNumbers(value)
            guard extractedNumbers.count == 3 else { return nil }
            return HSL(hue: min(extractedNumbers[0], 360),
                       saturation: min(extractedNumbers[1], 100) / 100,
                       lightness: min(extractedNumbers[2], 100) / 100).convertedToRGB
        }
    }
    
    func extractNumbers(_ string: String) -> [Double] {
        string.regexMatch(regex: "[0-9]+").compactMap(Double.init)
    }
    
    func setColorValue(_ rgb: RGB, inputedValue: String, editedType: ColorPickerType) {
        appState.colorPicker.currentRGB = (rgb.red, rgb.green, rgb.blue)
        appState.colorPicker.currentColorString[.hex] = (editedType != .hex) ? convertedToHexString(from: rgb.convertedToHex) : inputedValue
        appState.colorPicker.currentColorString[.rgb] = (editedType != .rgb) ? convertedToString(from: rgb) : inputedValue
        appState.colorPicker.currentColorString[.cmyk] = (editedType != .cmyk) ? convertedToString(from: rgb.convertedToCMYK) : inputedValue
        appState.colorPicker.currentColorString[.hsv] = (editedType != .hsv) ? convertedToString(from: rgb.convertedToHSV) : inputedValue
        appState.colorPicker.currentColorString[.hsl] = (editedType != .hsl) ? convertedToString(from: rgb.convertedToHSL) : inputedValue
    }
    
    func setColorValue(_ rgb: RGB) {
        appState.colorPicker.currentRGB = (rgb.red, rgb.green, rgb.blue)
        appState.colorPicker.currentColorString[.hex] = convertedToHexString(from: rgb.convertedToHex)
        appState.colorPicker.currentColorString[.rgb] = convertedToString(from: rgb)
        appState.colorPicker.currentColorString[.cmyk] = convertedToString(from: rgb.convertedToCMYK)
        appState.colorPicker.currentColorString[.hsv] = convertedToString(from: rgb.convertedToHSV)
        appState.colorPicker.currentColorString[.hsl] = convertedToString(from: rgb.convertedToHSL)
    }
}

// MARK: - Color Converter
private extension ColorPickerInteractor {
    func convertedToHexString(from hex: HEX) -> String {
        String(format: "#%06X", hex)
    }
    
    func convertedToString(from rgb: RGB) -> String {
        "\(Int(round(rgb.red))), \(Int(round(rgb.green))), \(Int(round(rgb.blue)))"
    }
    
    func convertedToString(from cmyk: CMYK) -> String {
        "\(Int(round(cmyk.cyan * 100)))%, \(Int(round(cmyk.magenta * 100)))%, \(Int(round(cmyk.yellow * 100)))%, \(Int(round(cmyk.black * 100)))%"
    }
    
    func convertedToString(from hsv: HSV) -> String {
        "\(Int(round(hsv.hue)))°, \(Int(round(hsv.saturation * 100)))%, \(Int(round(hsv.value * 100)))%"
    }
    
    func convertedToString(from hsl: HSL) -> String {
        "\(Int(round(hsl.hue)))°, \(Int(round(hsl.saturation * 100)))%, \(Int(round(hsl.lightness * 100)))%"
    }
}

struct StubColorPickerInteractor: ColorPickerInteractorProtocol {
    func inputColorValue(value: String, type: ColorPickerType) {}
    func inputColorValue(red: Double, green: Double, blue: Double) {}
    func inputPickerColorSpace(_ colorSpace: PickerColorSpace) {}
}
