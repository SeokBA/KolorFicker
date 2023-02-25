//
//  ContentView.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/06/12.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var toastBinder = ToastBinder()
    @State private var routedView: AnyView = AnyView(Color.secondary)
    
    var body: some View {
        ZStack {
            routedView
            ToastView(binder: toastBinder)
        }
        .onReceive(appState.$routing) {
            switch $0 {
            case .main:
                routedView = AnyView(MainView())
            case .picker:
                routedView = AnyView(ScreenColorPickerView())
            case let .toast(text):
                toastBinder.showToast(text)
            }
        }
        .frame(width: 680, height: 330)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}
