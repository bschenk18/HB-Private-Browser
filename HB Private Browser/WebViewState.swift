//
//  WebViewState.swift
//  HB Private Browser
//
//  Created by Benjamin Prentiss on 6/11/23.
//

import Combine
import SwiftUI
import WebKit

class WebViewState: ObservableObject {
    @Published var urlToLoad: URL?
    @Published var searchText = ""
    public var webView: WKWebView = WKWebView()

    func handleSearch(searchText: String) {
        guard let encodedSearch = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://duckduckgo.com/?q=\(encodedSearch)") else { return }
        urlToLoad = url
    }

    func refresh() {
        webView.reload()
    }

    func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
}



