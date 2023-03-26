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
        do {
            try setColorValue(rgbColorValue, inputedValue: value, editedType: type)
        } catch {
            print("Input color error: \(error)")
        }
    }
    
    func inputColorValue(red: Double, green: Double, blue: Double) {
        do {
            try setColorValue(RGB(red: red, green: green, blue: blue))
        } catch {
            print("Input color error: \(error)")
        }
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
            guard extractedNumbers.count == 3
            else { return nil }
            return RGB(red: min(extractedNumbers[0], 255),
                       green: min(extractedNumbers[1], 255),
                       blue: min(extractedNumbers[2], 255))
        case .cmyk:
            let extractedNumbers = extractNumbers(value)
            guard extractedNumbers.count == 4
            else { return nil }
            return convertedToRGB(c: min(extractedNumbers[0], 100),
                                  m: min(extractedNumbers[1], 100),
                                  y: min(extractedNumbers[2], 100),
                                  k: min(extractedNumbers[3], 100))
            
        case .hsv:
            let extractedNumbers = extractNumbers(value)
            guard extractedNumbers.count == 3
            else { return nil }
            return convertedToRGB(h: min(extractedNumbers[0], 360),
                                  s: min(extractedNumbers[1], 100) / 100,
                                  v: min(extractedNumbers[2], 100) / 100)
            
        case .hsl:
            let extractedNumbers = extractNumbers(value)
            guard extractedNumbers.count == 3
            else { return nil }
            return convertedToRGB(h: min(extractedNumbers[0], 360),
                                  s: min(extractedNumbers[1], 100) / 100,
                                  l: min(extractedNumbers[2], 100) / 100)
        }
    }
    
    func extractNumbers(_ string: String) -> [Double] {
        string.regexMatch(regex: "[0-9]+").compactMap(Double.init)
    }
    
    func setColorValue(_ rgbColorValue: RGB, inputedValue: String, editedType: ColorPickerType) throws {
        let cmyk = convertedToCMYK(r: rgbColorValue.red, g: rgbColorValue.green, b: rgbColorValue.blue)
        let hsv = try convertedToHSV(r: rgbColorValue.red, g: rgbColorValue.green, b: rgbColorValue.blue)
        let hsl = try convertedToHSL(r: rgbColorValue.red, g: rgbColorValue.green, b: rgbColorValue.blue)
        appState.colorPicker.currentRGB = (rgbColorValue.red, rgbColorValue.green, rgbColorValue.blue)
        appState.colorPicker.currentColorString[.hex] = (editedType != .hex) ? convertedToHexString(r: round(rgbColorValue.red), g: round(rgbColorValue.green), b: round(rgbColorValue.blue)) : inputedValue
        appState.colorPicker.currentColorString[.rgb] = (editedType != .rgb) ? "\(Int(round(rgbColorValue.red))), \(Int(round(rgbColorValue.green))), \(Int(round(rgbColorValue.blue)))" : inputedValue
        appState.colorPicker.currentColorString[.cmyk] = (editedType != .cmyk) ? "\(Int(round(cmyk.c * 100)))%, \(Int(round(cmyk.m * 100)))%, \(Int(round(cmyk.y * 100)))%, \(Int(round(cmyk.k * 100)))%" : inputedValue
        appState.colorPicker.currentColorString[.hsv] = (editedType != .hsv) ? "\(Int(round(hsv.h)))°, \(Int(round(hsv.s * 100)))%, \(Int(round(hsv.v * 100)))%" : inputedValue
        appState.colorPicker.currentColorString[.hsl] = (editedType != .hsl) ? "\(Int(round(hsl.h)))°, \(Int(round(hsl.s * 100)))%, \(Int(round(hsl.l * 100)))%" : inputedValue
    }
    
    func setColorValue(_ rgbColorValue: RGB) throws {
        let cmyk = convertedToCMYK(r: rgbColorValue.red, g: rgbColorValue.green, b: rgbColorValue.blue)
        let hsv = try convertedToHSV(r: rgbColorValue.red, g: rgbColorValue.green, b: rgbColorValue.blue)
        let hsl = try convertedToHSL(r: rgbColorValue.red, g: rgbColorValue.green, b: rgbColorValue.blue)
        appState.colorPicker.currentRGB = (rgbColorValue.red, rgbColorValue.green, rgbColorValue.blue)
        appState.colorPicker.currentColorString[.hex] = convertedToHexString(r: round(rgbColorValue.red), g: round(rgbColorValue.green), b: round(rgbColorValue.blue))
        appState.colorPicker.currentColorString[.rgb] = "\(Int(round(rgbColorValue.red))), \(Int(round(rgbColorValue.green))), \(Int(round(rgbColorValue.blue)))"
        appState.colorPicker.currentColorString[.cmyk] = "\(Int(round(cmyk.c * 100)))%, \(Int(round(cmyk.m * 100)))%, \(Int(round(cmyk.y * 100)))%, \(Int(round(cmyk.k * 100)))%"
        appState.colorPicker.currentColorString[.hsv] = "\(Int(round(hsv.h)))°, \(Int(round(hsv.s * 100)))%, \(Int(round(hsv.v * 100)))%"
        appState.colorPicker.currentColorString[.hsl] = "\(Int(round(hsl.h)))°, \(Int(round(hsl.s * 100)))%, \(Int(round(hsl.l * 100)))%"
    }
}

// MARK: - Color Converter
private extension ColorPickerInteractor {
    func convertedToRGB(c : Double, m : Double, y : Double, k : Double) -> RGB {
        let r = (1 - c) * (1 - k)
        let g = (1 - m) * (1 - k)
        let b = (1 - y) * (1 - k)
        return RGB(red: r, green: g, blue: b)
    }
    
    func convertedToRGB(h : Double, s : Double, v : Double) -> RGB {
        let c = v * s
        let x = c * (1 - abs((h / 60).truncatingRemainder(dividingBy: 2) - 1))
        let m = v - c
        return convertedToRGB(h: h, c: c, x: x, m: m)
    }
    
    func convertedToRGB(h : Double, s : Double, l : Double) -> RGB {
        let c = (1 - abs(2 * l - 1)) * s
        let x = c * (1 - abs((h / 60).truncatingRemainder(dividingBy: 2) - 1))
        let m = l - (c / 2)
        return convertedToRGB(h: h, c: c, x: x, m: m)
    }
    
    func convertedToRGB(h: Double, c: Double, x: Double, m: Double) -> RGB {
        let tranformedC = (c + m) * 255
        let tranformedX = (x + m) * 255
        let tranformedZero = m * 255
        
        switch(floor(h / 60)) {
        case 0:
            return RGB(red: tranformedC, green: tranformedX, blue: tranformedZero)
        case 1:
            return RGB(red: tranformedX, green: tranformedC, blue: tranformedZero)
        case 2:
            return RGB(red: tranformedZero, green: tranformedC, blue: tranformedX)
        case 3:
            return RGB(red: tranformedZero, green: tranformedX, blue: tranformedC)
        case 4:
            return RGB(red: tranformedX, green: tranformedZero, blue: tranformedC)
        default:
            return RGB(red: tranformedC, green: tranformedZero, blue: tranformedX)
        }
    }
    
    func convertedToHexString(r: Double, g: Double, b: Double) -> String {
        let hexValue = ((Int(r) << 16) + (Int(g) << 8) + Int(b)) & 0xFFFFFF
        return String(format: "#%06X", hexValue)
    }
    
    func convertedToCMYK(r : Double, g : Double, b : Double) -> (c : Double, m : Double, y : Double, k : Double) {
        let rDiv = (r == 0) ? 0 : r / 255
        let gDiv = (g == 0) ? 0 : g / 255
        let bDiv = (b == 0) ? 0 : b / 255
        
        let k = 1 - max(rDiv, gDiv, bDiv)
        guard k != 1 else { return (0, 0, 0, 1) }
        
        let c = (1 - rDiv - k) / (1 - k)
        let m = (1 - gDiv - k) / (1 - k)
        let y = (1 - bDiv - k) / (1 - k)
        
        return (c, m, y, k)
    }
    
    func convertedToHSV(r : Double, g : Double, b : Double) throws -> (h : Double, s : Double, v : Double) {
        let rDiv = (r == 0) ? 0 : r / 255
        let gDiv = (g == 0) ? 0 : g / 255
        let bDiv = (b == 0) ? 0 : b / 255
        
        let cMax = max(rDiv, gDiv, bDiv)
        let cMin = min(rDiv, gDiv, bDiv)
        let delta = cMax - cMin
        
        let h = try convertedToHue(r: r, g: g, b: b)
        let s = (cMax == 0) ? 0 : delta / cMax
        let v = cMax
        
        return (h, s, v)
    }
    
    func convertedToHSL(r : Double, g : Double, b : Double) throws -> (h : Double, s : Double, l : Double) {
        let rDiv = (r == 0) ? 0 : r / 255
        let gDiv = (g == 0) ? 0 : g / 255
        let bDiv = (b == 0) ? 0 : b / 255
        
        let cMax = max(rDiv, gDiv, bDiv)
        let cMin = min(rDiv, gDiv, bDiv)
        let delta = cMax - cMin
        
        let h = try convertedToHue(r: r, g: g, b: b)
        let l = (cMax + cMin) / 2
        let s = (delta == 0) ? 0 : delta / (1 - abs(2 * l - 1))
        
        return (h, s, l)
    }
    
    func convertedToHue(r : Double, g : Double, b : Double) throws -> Double {
        let rDiv = (r == 0) ? 0 : r / 255
        let gDiv = (g == 0) ? 0 : g / 255
        let bDiv = (b == 0) ? 0 : b / 255
        
        let cMax = max(rDiv, gDiv, bDiv)
        let cMin = min(rDiv, gDiv, bDiv)
        let delta = cMax - cMin
        
        if delta == 0 {
            return 0
        } else if cMax == rDiv {
            return 60 * ((gDiv - bDiv) / delta).truncatingRemainder(dividingBy: 6)
        } else if cMax == gDiv {
            return 60 * (((bDiv - rDiv) / delta) + 2)
        } else if cMax == bDiv {
            return 60 * (((rDiv - gDiv) / delta) + 4)
        } else {
            throw ColorPickerError.notConvertedToHue
        }
    }
}

struct StubColorPickerInteractor: ColorPickerInteractorProtocol {
    func inputColorValue(value: String, type: ColorPickerType) {}
    func inputColorValue(red: Double, green: Double, blue: Double) {}
    func inputPickerColorSpace(_ colorSpace: PickerColorSpace) {}
}
