//
//  ScreenColorPickerView.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/10/01.
//

import SwiftUI

struct ScreenColorPickerView: View {
    @EnvironmentObject private var appState: AppState
    
    @Environment(\.interactors?.colorPicker) private var interactor
    @Environment(\.interactors?.router) private var router
    
    @State private var image: Image?
    @State private var color: Color?
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Click the screen outside this window to select a color.")
                    .foregroundColor(.secondary)
                
                Menu {
                    ForEach(PickerColorSpace.allCases) { colorSpace in
                        Button(colorSpace.description, action: { interactor?.inputPickerColorSpace(colorSpace) })
                    }
                } label: {
                    Text(appState.colorPicker.currentPickerColorSpace.description)
                }
                .frame(width: 100)
                
                Spacer()
                
                CircleTooltipButton(systemImageName: "xmark",
                                    description: "cancel",
                                    perform: tooltipButtonAction)
            }
            
            HStack(spacing: 0) {
                ScreenMonitoringView(image: $image,
                                     color: $color,
                                     clickedAction: screenDidClick)
                .cornerRadius(10)
                .aspectRatio(1, contentMode: .fit)
                .shadow(radius: 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.secondary)
                        .aspectRatio(1, contentMode: .fit)
                        .shadow(radius: 10)
                )
                .padding(10)
                
                Canvas { context, size in
                    var path = Path()
                    let edge = size.width / 2
                    path.move(to: CGPoint(x: 0, y: edge))
                    path.addLine(to: CGPoint(x: 0, y: size.height - edge))
                    path.addLine(to: CGPoint(x: size.width, y: size.height))
                    path.addLine(to: CGPoint(x: size.width, y: 0))
                    context.fill(path, with: .color(.secondary.opacity(0.1)))
                }
                .frame(width: 100)
                .padding(.vertical, 35)
                .padding(.leading, 10)
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(color ?? .secondary)
                    .aspectRatio(1, contentMode: .fit)
                    .shadow(radius: 10)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.secondary.opacity(0.1), lineWidth: 1)
                    )
                    .padding(19)
            }
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
    }
}

private extension ScreenColorPickerView {
    func screenDidClick() {
        guard let color = color else { return }
        let nsColor = NSColor(color)
        interactor?.inputColorValue(red: nsColor.redComponent * 255, green: nsColor.greenComponent * 255, blue: nsColor.blueComponent * 255)
        router?.route(to: .main)
    }
    
    func tooltipButtonAction() {
        DispatchQueue.main.async {
            router?.route(to: .main)
        }
    }
}

struct ScreenColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenColorPickerView()
            .frame(width: 680, height: 330)
    }
}
