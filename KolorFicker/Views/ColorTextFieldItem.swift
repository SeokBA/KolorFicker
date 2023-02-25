//
//  ColorTextFieldItem.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/06/12.
//

import SwiftUI

struct ColorTextFieldItem: View {
    @Environment(\.interactors?.router) private var router
    @State private var isHoveredOnCopyButton = false
    @Binding private var colorTextBinding: String
    private let type: ColorPickerType
    
    init(type: ColorPickerType, colorTextBinding: Binding<String>) {
        self.type = type
        self._colorTextBinding = colorTextBinding
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Text(type.title)
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(width: 40, alignment: .leading)
            
            TextField(type.title, text: $colorTextBinding)
                .textFieldStyle(.plain)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Color("TertiaryColor")
                        .opacity(0.6)
                )
                .cornerRadius(3)
                .frame(width: 200)
            
            Button(action: {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(colorTextBinding, forType: .string)
                router?.route(to: .toast("Copy success! (\(colorTextBinding))"))
            }) {
                Image(systemName: "doc.on.clipboard.fill")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 3)
                    .background(.tertiary)
                    .background((isHoveredOnCopyButton) ? .gray.opacity(0.5) : .clear)
                    .cornerRadius(5)
                    .onHover { isHoveredOnCopyButton = $0 }
            }
            .buttonStyle(.plain)
        }
        .padding(10)
        .background(VisualEffect())
        .cornerRadius(5)
        .shadow(radius: 5)
    }
}

struct ColorTextFieldItem_Previews: PreviewProvider {
    static var previews: some View {
        ColorTextFieldItem(type: .rgb, colorTextBinding: .constant("#ededed"))
            .padding()
            .preferredColorScheme(.light)
        
        ColorTextFieldItem(type: .rgb, colorTextBinding: .constant("#ededed"))
            .padding()
            .preferredColorScheme(.dark)
    }
}
