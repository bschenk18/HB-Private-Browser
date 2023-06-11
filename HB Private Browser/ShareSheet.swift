//
//  ShareSheet.swift
//  HB Private Browser
//
//  Created by Benjamin Prentiss on 6/11/23.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Not needed
    }
}

