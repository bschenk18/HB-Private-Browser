//
//  DismissableKeyboard.swift
//  HB Private Browser
//
//  Created by Benjamin Prentiss on 6/11/23.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

