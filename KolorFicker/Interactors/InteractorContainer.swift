//
//  InteractorContainer.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/06/12.
//

import Foundation

struct InteractorContainer {
    let colorPicker: ColorPickerInteractorProtocol
    let router: RouteInteractorProtocol
}

extension InteractorContainer {
    static let stub = InteractorContainer(colorPicker: StubColorPickerInteractor(),
                                          router: StubRouteInteractor())
}
