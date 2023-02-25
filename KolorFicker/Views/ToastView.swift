//
//  ToastView.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/10/03.
//

import SwiftUI
import Combine

final class ToastBinder: ObservableObject {
    @Published public var toastText = ""
    private var timer: Timer?
    
    func showToast(_ text: String) {
        timer?.invalidate()
        withAnimation(.easeOut.speed(4)) {
            toastText = text
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            withAnimation(.easeIn.speed(4)) {
                self?.toastText = ""
            }
        }
    }
}

struct ToastView: View {
    @ObservedObject private var binder: ToastBinder
    
    init(binder: ToastBinder) {
        self.binder = binder
    }
    
    var body: some View {
        VStack {
            if !binder.toastText.isEmpty {
                Text(binder.toastText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .foregroundColor(.secondary)
                    .cornerRadius(5)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(binder: ToastBinder())
            .frame(width: 680, height: 330)
    }
}
