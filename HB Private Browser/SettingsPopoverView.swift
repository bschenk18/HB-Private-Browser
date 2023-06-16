//
//  SettingsPopoverView.swift
//  HB Private Browser
//
//  Created by Benjamin Prentiss on 6/16/23.
//

import SwiftUI
import LocalAuthentication

struct SettingsPopoverView: View {
    @Binding var showingPopover: Bool
    @Binding var isFaceIDProtected: Bool
    @Binding var isIncognitoModeOn: Bool
    @Binding var isAutoEncryptionOn: Bool
    @Binding var isSecureStorageOn: Bool
    
    var body: some View {
        VStack {
            Spacer()

            VStack {
                HStack {
                    Text("Face ID:")
                    Spacer()
                    Toggle("", isOn: $isFaceIDProtected)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .labelsHidden()
                }.padding()

                Divider()

                HStack {
                    Text("Incognito Mode:")
                    Spacer()
                    Toggle("", isOn: $isIncognitoModeOn)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .labelsHidden()
                }.padding()

                Divider()

                HStack {
                    Text("Auto-Encryption:")
                    Spacer()
                    Toggle("", isOn: $isAutoEncryptionOn)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .labelsHidden()
                }.padding()

                Divider()

                HStack {
                    Text("Secure Storage:")
                    Spacer()
                    Toggle("", isOn: $isSecureStorageOn)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .labelsHidden()
                }.padding()
            }
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .frame(maxHeight: UIScreen.main.bounds.height / 2)
            .padding(.horizontal)
            .transition(.move(edge: .bottom))
        }
        .environment(\.colorScheme, .dark)
        .background(Color.gray.opacity(0.1).onTapGesture {
            self.showingPopover = false
        })
        .edgesIgnoringSafeArea(.all)
    }
}

