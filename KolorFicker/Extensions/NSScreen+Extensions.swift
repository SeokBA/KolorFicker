//
//  NSScreen+Extensions.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/07/09.
//

import Cocoa

public extension NSScreen {
    static func getScreen(_ point:NSPoint) -> NSScreen {
        var screenRes:NSScreen?
        if let screens = NSScreen.screens as [NSScreen]? {
            for screen in screens {
                if NSMouseInRect(point, screen.frame, false) {
                    screenRes = screen
                }
            }
        }
        return screenRes!
    }
}
