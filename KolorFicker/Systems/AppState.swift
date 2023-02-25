//
//  AppState.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/06/12.
//

import Foundation

final class AppState: ObservableObject {
    @Published var colorPicker = ColorPickerState()
    @Published var routing = Routing.main
}

struct ColorPickerState {
    var currentRGB: (red: Double, blue: Double, green: Double) = (3, 252, 28)
    var currentColorString = [ColorPickerType.hex: "#03FC1C",
                              ColorPickerType.rgb: "3, 252, 28",
                              ColorPickerType.cmyk : "99%, 0%, 89%, 1%",
                              ColorPickerType.hsv : "126°, 99%, 99%",
                              ColorPickerType.hsl : "126°, 98%, 50%"]
    var currentPickerColorSpace = PickerColorSpace.default
}

extension AppState {
    static let stub: AppState = {
        let appState = AppState()
        return appState
    }()
}

enum Routing {
    case main
    case picker
    case toast(_ description: String)
}
