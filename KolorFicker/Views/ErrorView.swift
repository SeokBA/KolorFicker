//
//  ErrorView.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/10/03.
//

import SwiftUI

struct ErrorView: View {
    private let title: String?
    private let description: String
    
    init(title: String? = nil, description: String) {
        self.title = title
        self.description = description
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            
            Text(title ?? "Error Occurred")
                .font(.largeTitle)
                .bold()
            
            Text(description)
                .font(.headline)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.secondary)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(description: "error descriptoin")
            .frame(width: 680, height: 330)
    }
}
