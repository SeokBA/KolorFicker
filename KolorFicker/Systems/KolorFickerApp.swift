//
//  KolorFickerApp.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/06/12.
//

import SwiftUI

struct VisualEffect: NSViewRepresentable {
    func makeNSView(context: Self.Context) -> NSView {
        let visualEffect = NSVisualEffectView()
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .fullScreenUI
        visualEffect.layer?.opacity = 0.1
        return visualEffect
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

@main
struct KolorFickerApp: App {
    @AppStorage("latestRGBColorString") var latestRGBColorString = "\(Int.random(in: 0...255)), \(Int.random(in: 0...255)), \(Int.random(in: 0...255))"
    @State private var mainWindow: NSWindow?
    
    private let appState = AppState()
    private let interactors: InteractorContainer
    
    private let windowSize = NSSize(width: 680, height: 300)
    
    init() {
        interactors = InteractorContainer(colorPicker: ColorPickerInteractor(appState: appState),
                                          router: RouteInteractor(appState: appState))
        interactors.colorPicker.inputColorValue(value: latestRGBColorString, type: .rgb)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(\.interactors, interactors)
                .window(mainWindowBinding)
                .background(VisualEffect().ignoresSafeArea())
                .onReceive(appState.$colorPicker) {
                    guard let rgbString = $0.currentColorString[.rgb] else { return }
                    latestRGBColorString = rgbString
                }
        }
        .windowStyle(.hiddenTitleBar)
    }
}

private extension KolorFickerApp {
    var mainWindowBinding: Binding<NSWindow?> {
        Binding(get: {
            mainWindow
        }, set: {
            mainWindow = $0
            guard let window = $0 else { return }
            configureWindow(window)
        })
    }
    
    func configureWindow(_ window: NSWindow) {
        window.level = .floating
        window.styleMask.subtract(.resizable)
        window.setContentSize(windowSize)
        window.isOpaque = false
    }
}
