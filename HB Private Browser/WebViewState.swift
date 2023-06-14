import Combine
import SwiftUI
import WebKit

class WebViewState: ObservableObject {
    @Published var urlToLoad: URL?
    @Published var searchText = ""
    public var webView: WKWebView?
    
    private var trackingPreventionConfiguration: WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        configuration.preferences = WKPreferences()
        
        let webpagePreferences = WKWebpagePreferences()
        webpagePreferences.allowsContentJavaScript = false
        configuration.defaultWebpagePreferences = webpagePreferences
        
        return configuration
    }
    
    func handleSearch(searchText: String) {
        guard let encodedSearch = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://duckduckgo.com/?q=\(encodedSearch)") else { return }
        urlToLoad = url
    }
    
    func refresh() {
        webView?.reload()
    }
    
    func goBack() {
        webView?.goBack()
    }
    
    func goForward() {
        webView?.goForward()
    }
    
    func setupWebView() {
        let configuration = trackingPreventionConfiguration
        webView = WKWebView(frame: .zero, configuration: configuration)
    }
}
