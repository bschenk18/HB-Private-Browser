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
    let objectWillChange = PassthroughSubject<Void, Never>()
    var webView: WKWebView? {
        didSet {
            objectWillChange.send()
        }
    }
    @Published var searchText = ""
    @Published var urlToLoad: URL?
    
    func handleSearch(searchText: String) {
        guard let encodedSearch = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://duckduckgo.com/?q=\(encodedSearch)") else { return }
        urlToLoad = url
    }
    
    func refresh() {
        webView?.reload()
    }
}


