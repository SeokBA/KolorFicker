//
//  CircleTooltipButton.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/10/01.
//

import SwiftUI

struct CircleTooltipButton: View {
    @State private var isHoverdOnView = false
    
    private let systemImageName: String
    private let description: String
    private let action: () -> Void
    
    init(systemImageName: String,
         description: String,
         perform action: @escaping () -> Void)
    {
        self.systemImageName = systemImageName
        self.description = description
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Group {
                if isHoverdOnView {
                    hoverOnButtonFrameView
                } else {
                    defaultButtonFrameView
                }
            }
            .shadow(radius: 5)
        }
        .buttonStyle(.plain)
        .onHover {
            isHoverdOnView = $0
        }
    }
}

private extension CircleTooltipButton {
    private var defaultButtonFrameView: some View {
        Image(systemName: systemImageName)
            .font(.headline)
            .padding(5)
            .background(VisualEffect())
            .clipShape(Circle())
            .contentShape(Circle())
    }
    
    private var hoverOnButtonFrameView: some View {
        HStack(spacing: 5) {
            Text(description)
                .font(.caption)
                .padding(.horizontal, 5)
            
            Image(systemName: systemImageName)
                .font(.headline)
        }
        .padding(5)
        .background(VisualEffect())
        .clipShape(Capsule())
        .contentShape(Capsule())
    }
}

struct CircleTooltipButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleTooltipButton(systemImageName: "user", description: "user", perform: {})
    }
}
