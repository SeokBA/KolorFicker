//
//  PickerColorSpace.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/10/25.
//

import SwiftUI

enum PickerColorSpace: CaseIterable {
    case `default`, P3, sRGB, genericRGB, adobeRGB//, lab
}

extension PickerColorSpace {
    var description: String {
        switch self {
        case .default:
            return "default"
            
        case .P3:
            return "P3"
            
        case .sRGB:
            return "sRGB"
            
        case .genericRGB:
            return "generic RGB"
            
        case .adobeRGB:
            return "Adobe RGB"
            
//        case .lab:
//            return "L*a*b*"
        }
    }
    
    var colorSpace: NSColorSpace? {
        switch self {
        case .default:
            return nil
            
        case .P3:
            return .displayP3
        case .sRGB:
            return .sRGB
            
        case .genericRGB:
            return .genericRGB
            
        case .adobeRGB:
            return .adobeRGB1998
            
//        case .lab:
//            return NSColorSpace.Model.lab
        }
    }
}

extension PickerColorSpace: Identifiable {
    var id: String {
        description
    }
}
