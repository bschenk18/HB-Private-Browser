//
//  WebViewWrapper.swift
//  HB Private Browser
//
//  Created by Benjamin Prentiss on 6/11/23.
//

import SwiftUI
import WebKit

struct WebViewWrapper: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

