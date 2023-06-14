import Combine
import SwiftUI
import WebKit

class WebViewState: ObservableObject {
    @Published var urlToLoad: URL?
    @Published var searchText = ""
    @Published var isIncognitoModeOn = true
    @Published var isDNTEnabled = true
    @Published var isUserAgentSpoofingEnabled = true
    @Published var isAdBlockEnabled = true // New property for ad-blocking
    
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
        
        // Configure Ad Blocking
        if isAdBlockEnabled {
            enableAdBlock()
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
        
        // Scroll to top after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.webView?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
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
    
    private func enableAdBlock() {
        let adBlockScript = """
        var style = document.createElement('style');
        style.innerHTML = 'body > *:not(.ad) { display: none !important; }';
        document.head.appendChild(style);
        """
        
        let userScript = WKUserScript(source: adBlockScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        webView?.configuration.userContentController.addUserScript(userScript)
    }
    
    // MARK: - Cookie Management
    
    func getCookies(completion: @escaping ([HTTPCookie]) -> Void) {
        webView?.configuration.websiteDataStore.httpCookieStore.getAllCookies(completion)
    }
    
    func deleteCookie(_ cookie: HTTPCookie) {
        webView?.configuration.websiteDataStore.httpCookieStore.delete(cookie)
    }
    
    func deleteAllCookies() {
        webView?.configuration.websiteDataStore.httpCookieStore.getAllCookies { [weak self] cookies in
            cookies.forEach { cookie in
                self?.webView?.configuration.websiteDataStore.httpCookieStore.delete(cookie)
            }
        }
    }
}
