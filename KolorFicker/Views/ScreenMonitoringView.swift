//
//  ScreenMonitoringView.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/06/14.
//

import SwiftUI

struct ScreenMonitoringView: NSViewRepresentable {
    @EnvironmentObject private var appState: AppState
    
    @Binding var image: Image?
    @Binding var color: Color?
    
    var clickedAction: (() -> Void)?
    
    func makeNSView(context: Context) -> ScreenMonitoringNSView {
        ScreenMonitoringNSView(parent: self, colorSpace: appState.colorPicker.currentPickerColorSpace.colorSpace)
    }
    
    func updateNSView(_ nsView: ScreenMonitoringNSView, context: Context) {
        nsView.setNeedsDisplay(nsView.bounds)
    }
}

final class ScreenMonitoringNSView: NSView {
    let halfLength: CGFloat = 9.5
    let captureLength: CGFloat = 1
    
    private var localMouseMovedMonitor: Any?
    private var globalMouseMovedMonitor: Any?
    private var globalLeftMouseUpMonitor: Any?
    
    private var cgImage: CGImage?
    private var colorSpace: NSColorSpace?
    
    init(parent: ScreenMonitoringView, colorSpace: NSColorSpace?) {
        super.init(frame: .zero)
        
        localMouseMovedMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { [weak self] in
            self?.makeImage(parent: parent)
            return $0
        }
        
        globalMouseMovedMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { [weak self] _ in
            self?.makeImage(parent: parent)
        }
        
        globalLeftMouseUpMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseUp]) { _ in
            parent.clickedAction?()
        }
        
        self.colorSpace = colorSpace
    }
    
    deinit {
        if let localMouseMovedMonitor = localMouseMovedMonitor {
            NSEvent.removeMonitor(localMouseMovedMonitor)
        }
        
        if let globalMouseMovedMonitor = globalMouseMovedMonitor {
            NSEvent.removeMonitor(globalMouseMovedMonitor)
        }
        
        if let globalLeftMouseUpMonitor = globalLeftMouseUpMonitor {
            NSEvent.removeMonitor(globalLeftMouseUpMonitor)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let screen = NSScreen.getScreen(NSEvent.mouseLocation)
        
        let context = NSGraphicsContext.current!.cgContext
        context.interpolationQuality = .none
        context.setShouldAntialias(false)
        
        if let cgImage = cgImage {
            context.draw(cgImage, in: NSRectToCGRect(bounds))
        }
        
        let apertureRect:CGRect = CGRect(x: floor(dirtyRect.center.x) - (dirtyRect.width / (halfLength * screen.backingScaleFactor)) / 2,
                                         y: floor(dirtyRect.center.y) - (dirtyRect.width / (halfLength * screen.backingScaleFactor)) / 2,
                                         width: dirtyRect.width / (halfLength * screen.backingScaleFactor),
                                         height: dirtyRect.height / (halfLength * screen.backingScaleFactor));
        context.setStrokeColor(red: 1.0, green: 0, blue: 0, alpha: 1)
        drawBorderForRect(context, rect: apertureRect)
    }
    
    func updateView(_ image: CGImage?, rect: NSRect) {
        cgImage = image
        setNeedsDisplay(bounds)
    }
    
    func drawBorderForRect(_ context: CGContext, rect: CGRect) {
        let x:CGFloat = rect.origin.x;
        let y:CGFloat = rect.origin.y;
        let w:CGFloat = rect.size.width;
        let h:CGFloat = rect.size.height;
        
        context.beginPath();
        context.move(to: CGPoint(x: x, y: y));
        context.addLine(to: CGPoint(x: x + w, y: y));
        context.move(to: CGPoint(x: x + w, y: y));
        context.addLine(to: CGPoint(x: x + w, y: y + h));
        context.move(to: CGPoint(x: x + w, y: y + h));
        context.addLine(to: CGPoint(x: x, y: y + h));
        context.move(to: CGPoint(x: x, y: y + h));
        context.addLine(to: CGPoint(x: x, y: y));
        context.strokePath();
    }
}

private extension ScreenMonitoringNSView {
    func makeImage(parent: ScreenMonitoringView) {
        let screenFrame = NSScreen.main!.frame
        
        var point = NSEvent.mouseLocation
        let screen = NSScreen.getScreen(point)
        
        point.x = point.x - halfLength
        point.y = (screenFrame.maxY - point.y) - halfLength
        let length = halfLength * 2
        let rect = CGRect(origin: point, size: CGSize(width: length, height: length))
        
        if let cgImage = CGWindowListCreateImage(rect, .optionOnScreenBelowWindow, kCGNullWindowID, .nominalResolution) {
            updateView(cgImage, rect: rect)
            parent.image = Image(cgImage, scale: screen.backingScaleFactor, label: Text("captured image"))
            parent.color = colorAtCenter(screen: screen, imageRef: cgImage)
        } else {
            updateView(nil, rect: rect)
            parent.image = nil
            parent.color = nil
        }
    }
    
    func colorAtCenter(screen:NSScreen, imageRef:CGImage) -> Color? {
        let bitmap = NSBitmapImageRep(cgImage: imageRef)
        let x = Int(imageRef.width / 2)
        let y = Int(imageRef.height / 2)
        guard let color = bitmap.colorAt(x: x, y: y) else { return nil }
        
        let compCount = color.numberOfComponents
        let comps = UnsafeMutablePointer<CGFloat>.allocate(capacity: compCount)
        color.getComponents(comps)
        var nsColor = NSColor(colorSpace: bitmap.colorSpace, components: comps, count: compCount)
        if let colorSpace, let convertedColor = nsColor.usingColorSpace(colorSpace) {
            nsColor = convertedColor
        }
        return Color(nsColor: nsColor)
    }
}
