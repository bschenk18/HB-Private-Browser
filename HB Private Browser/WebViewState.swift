import Combine
import SwiftUI
import WebKit

class WebViewState: ObservableObject {
    @Published var urlToLoad: URL?
    @Published var searchText = ""
    @Published var isIncognitoModeOn = false
    @Published var isDNTEnabled = false
    public var webView: WKWebView?
    
    private var configuration: WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = isIncognitoModeOn ? WKWebsiteDataStore.nonPersistent() : WKWebsiteDataStore.default()
        configuration.preferences = WKPreferences()
        
        let webpagePreferences = WKWebpagePreferences()
        webpagePreferences.allowsContentJavaScript = !isIncognitoModeOn
        configuration.defaultWebpagePreferences = webpagePreferences
        
        // Configure Do Not Track (DNT)
        if isDNTEnabled {
            enableDNT()
        } else {
            disableDNT()
        }
        
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
        let configuration = self.configuration
        webView = WKWebView(frame: .zero, configuration: configuration)
    }
    
    private func enableDNT() {
        let script = "navigator.doNotTrack = '1';"
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        
        webView?.configuration.userContentController.addUserScript(userScript)
    }
    
    private func disableDNT() {
        let script = "navigator.doNotTrack = '0';"
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        
        webView?.configuration.userContentController.addUserScript(userScript)
    }
}
