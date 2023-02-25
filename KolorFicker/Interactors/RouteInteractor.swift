//
//  RouteInteractor.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/10/01.
//

import Foundation

protocol RouteInteractorProtocol {
    func route(to routing: Routing)
}

final class RouteInteractor {
    private let appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
}

extension RouteInteractor: RouteInteractorProtocol {
    func route(to routing: Routing) {
        appState.routing = routing
    }
}

struct StubRouteInteractor: RouteInteractorProtocol {
    func route(to routing: Routing) {}
}
