//
//  WebViewState.swift
//  HB Private Browser
//
//  Created by Benjamin Prentiss on 6/11/23.
//

import SwiftUI

class WebViewState: ObservableObject {
    @Published var urlToLoad: URL?
    @Published var searchText = ""

    func handleSearch(searchText: String) {
        guard let encodedSearch = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://duckduckgo.com/?q=\(encodedSearch)") else { return }
        urlToLoad = url
    }
}

