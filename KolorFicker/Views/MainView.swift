//
//  MainView.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/06/12.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.interactors?.colorPicker) private var interactor
    @Environment(\.interactors?.router) private var router
    @Environment(\.openURL) var openURL
    @State private var isShowedSystemPermissionAlert = false
    @State private var showsScreenPermissionAlert = false
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                CircleTooltipButton(systemImageName: "cursorarrow.rays",
                                    description: "Picking the color of the screen",
                                    perform: tooltipButtonAction)
            }
            
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(currentColor)
                    .aspectRatio(1, contentMode: .fit)
                    .shadow(radius: 10)
                
                Spacer()
                
                VStack(spacing: 10) {
                    ForEach(ColorPickerType.allCases) {
                        ColorTextFieldItem(type: $0, colorTextBinding: colorTextBinding(type: $0))
                            .fixedSize()
                    }
                }
            }
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
        .alert(isPresented: $showsScreenPermissionAlert) {
            Alert(title: Text("Screen capture permission required"),
                  message: Text("To get the screen's color, the app requires screen capture permission."),
                  primaryButton: .default(
                    Text("Open System Preferences"),
                    action: routeToSystemPreferences
                  ),
                  secondaryButton: .cancel())
        }
    }
}

private extension MainView {
    var hasScreenAccess: Bool {
        CGPreflightScreenCaptureAccess()
    }
    
    func requestScreenAccesssPermission() -> Bool{
        CGRequestScreenCaptureAccess()
    }
    
    func routeToSystemPreferences() {
        openURL(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")!)
    }
    
    var currentColor: Color {
        let currentRGB = appState.colorPicker.currentRGB
        return Color(red: currentRGB.0 / 255, green: currentRGB.1 / 255, blue: currentRGB.2 / 255)
    }
    
    func colorTextBinding(type: ColorPickerType) -> Binding<String> {
        Binding(get: {
            appState.colorPicker.currentColorString[type] ?? ""
        }, set: {
            interactor?.inputColorValue(value: $0, type: type)
        })
    }
    
    func tooltipButtonAction() {
        guard hasScreenAccess else {
            guard isShowedSystemPermissionAlert else {
                _ = requestScreenAccesssPermission()
                isShowedSystemPermissionAlert = true
                return
            }
            showsScreenPermissionAlert = true
            return
        }
        
        DispatchQueue.main.async {
            router?.route(to: .picker)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .preferredColorScheme(.light)
            
            MainView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(AppState.stub)
        .previewLayout(.sizeThatFits)
    }
}
