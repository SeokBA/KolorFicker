//
//  Environments.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/06/12.
//

import SwiftUI

private struct InteractorContainerKey: EnvironmentKey {
    static let defaultValue: InteractorContainer? = nil
}

extension EnvironmentValues {
    var interactors: InteractorContainer? {
        get { self[InteractorContainerKey.self] }
        set { self[InteractorContainerKey.self] = newValue }
    }
}
