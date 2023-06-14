import Combine
import SwiftUI
import WebKit

class WebViewState: ObservableObject {
    @Published var urlToLoad: URL?
    @Published var searchText = ""
    @Published var isIncognitoModeOn = true
    @Published var isDNTEnabled = true
    @Published var isUserAgentSpoofingEnabled = true
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
        
        // Configure User Agent Spoofing
        if isUserAgentSpoofingEnabled {
            configureUserAgentSpoofing()
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
    
    private func configureUserAgentSpoofing() {
        // Replace with the desired user agent string
        let userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        
        webView?.customUserAgent = userAgent
    }
}
