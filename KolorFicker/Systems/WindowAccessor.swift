//
//  WindowAccessor.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/08/16.
//

import SwiftUI

public extension View {
    func window(_ windowBinding: Binding<NSWindow?>) -> some View {
        background(WindowAccessor(window: windowBinding))
    }
}

fileprivate struct WindowAccessor: NSViewRepresentable {
    @Binding var window: NSWindow?
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            guard let window = view.window else { return }
            self.window = window
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        nsView.setNeedsDisplay(nsView.bounds)
    }
}
