//
//  ColorConvertable.swift
//  KolorFicker
//
//  Created by tuna.can on 2023/03/26.
//

import Foundation

public protocol ColorConvertable {}

public extension ColorConvertable {
    func convertedToRGB(from cmyk: CMYK) -> RGB {
        let red = (1 - cmyk.cyan) * (1 - cmyk.black)
        let green = (1 - cmyk.magenta) * (1 - cmyk.black)
        let blue = (1 - cmyk.yellow) * (1 - cmyk.black)
        return RGB(red: red, green: green, blue: blue)
    }
    
    func convertedToRGB(from hsv: HSV) -> RGB {
        let c = hsv.value * hsv.saturation
        let x = c * (1 - abs((hsv.hue / 60).truncatingRemainder(dividingBy: 2) - 1))
        let m = hsv.value - c
        return convertedToRGB(hue: hsv.hue, c: c, x: x, m: m)
    }
    
    func convertedToRGB(from hsl: HSL) -> RGB {
        let c = (1 - abs(2 * hsl.lightness - 1)) * hsl.saturation
        let x = c * (1 - abs((hsl.hue / 60).truncatingRemainder(dividingBy: 2) - 1))
        let m = hsl.lightness - (c / 2)
        return convertedToRGB(hue: hsl.hue, c: c, x: x, m: m)
    }
    
    func convertedToHex(from rgb: RGB) -> HEX {
        ((Int(rgb.red) << 16) + (Int(rgb.green) << 8) + Int(rgb.blue)) & 0xFFFFFF
    }
    
    func convertedToCMYK(from rgb: RGB) -> CMYK {
        let rDiv = (rgb.red == 0) ? 0 : rgb.red / 255
        let gDiv = (rgb.green == 0) ? 0 : rgb.green / 255
        let bDiv = (rgb.blue == 0) ? 0 : rgb.blue / 255
        
        let black = 1 - max(rDiv, gDiv, bDiv)
        guard black != 1 else { return CMYK(cyan: 0, magenta: 0, yellow: 0, black: 1) }
        
        let cyan = (1 - rDiv - black) / (1 - black)
        let magenta = (1 - gDiv - black) / (1 - black)
        let yellow = (1 - bDiv - black) / (1 - black)
        
        return CMYK(cyan: cyan,
                    magenta: magenta,
                    yellow: yellow,
                    black: black)
    }
    
    func convertedToHSV(from rgb: RGB) -> HSV {
        let rDiv = (rgb.red == 0) ? 0 : rgb.red / 255
        let gDiv = (rgb.green == 0) ? 0 : rgb.green / 255
        let bDiv = (rgb.blue == 0) ? 0 : rgb.blue / 255
        
        let cMax = max(rDiv, gDiv, bDiv)
        let cMin = min(rDiv, gDiv, bDiv)
        let delta = cMax - cMin
        
        let hue = convertedToHue(from: rgb)
        let saturation = (cMax == 0) ? 0 : delta / cMax
        let value = cMax
        
        return HSV(hue: hue,
                   saturation: saturation,
                   value: value)
    }
    
    func convertedToHSL(from rgb: RGB) -> HSL {
        let rDiv = (rgb.red == 0) ? 0 : rgb.red / 255
        let gDiv = (rgb.green == 0) ? 0 : rgb.green / 255
        let bDiv = (rgb.blue == 0) ? 0 : rgb.blue / 255
        
        let cMax = max(rDiv, gDiv, bDiv)
        let cMin = min(rDiv, gDiv, bDiv)
        let delta = cMax - cMin
        
        let hue = convertedToHue(from: rgb)
        let lightness = (cMax + cMin) / 2
        let saturation = (delta == 0) ? 0 : delta / (1 - abs(2 * lightness - 1))
        
        return HSL(hue: hue,
                   saturation: saturation,
                   lightness: lightness)
    }
}

private extension ColorConvertable {
    func convertedToRGB(hue: Double, c: Double, x: Double, m: Double) -> RGB {
        let tranformedC = (c + m) * 255
        let tranformedX = (x + m) * 255
        let tranformedZero = m * 255
        
        switch(floor(hue / 60)) {
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
    
    func convertedToHue(from rgb: RGB) -> Double {
        let rDiv = (rgb.red == 0) ? 0 : rgb.red / 255
        let gDiv = (rgb.green == 0) ? 0 : rgb.green / 255
        let bDiv = (rgb.blue == 0) ? 0 : rgb.blue / 255
        
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
            return 0
        }
    }
}
