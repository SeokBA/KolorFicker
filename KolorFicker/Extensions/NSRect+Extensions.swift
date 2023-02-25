//
//  NSRect+Extensions.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/07/09.
//

import Cocoa

public extension NSRect {
    var center: NSPoint {
        NSPoint(x: origin.x + size.width / 2,
                y: origin.y + size.height / 2)
    }
}
