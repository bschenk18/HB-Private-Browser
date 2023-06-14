import Combine
import SwiftUI
import WebKit

class WebViewState: ObservableObject {
    @Published var urlToLoad: URL?
    @Published var searchText = ""
    @Published var isIncognitoModeOn = true
    @Published var isDNTEnabled = true
    @Published var isUserAgentSpoofingEnabled = true
    @Published var isHyperBoldEnabled = false

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
        
        // Scroll to top after a short delay
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                           self.webView?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                       }
    }

    func goBack() {
        webView?.goBack()
        
        // Scroll to top after a short delay
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                           self.webView?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                       }
    }

    func goForward() {
        webView?.goForward()
        
        // Scroll to top after a short delay
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                           self.webView?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                       }
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

    func toggleHyperBold() {
        isHyperBoldEnabled.toggle()

        let script = """
        var elements = document.querySelectorAll('p, span, h1, h2, h3, h4, h5, h6, em, i, strong, b, li');
        for (var i = 0; i < elements.length; i++) {
            var words = elements[i].innerText.split(' ');
            for (var j = 0; j < words.length; j++) {
                var length = words[j].length;
                if (length <= 2) {
                    words[j] = '<b>' + words[j] + '</b>';
                } else if (length <= 5) {
                    words[j] = '<b>' + words[j].substring(0, 2) + '</b>' + words[j].substring(2);
                } else if (length <= 7) {
                    words[j] = '<b>' + words[j].substring(0, 3) + '</b>' + words[j].substring(3);
                } else {
                    words[j] = '<b>' + words[j].substring(0, 4) + '</b>' + words[j].substring(4);
                }
            }
            elements[i].innerHTML = words.join(' ');
        }
        """

        let userScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        if isHyperBoldEnabled {
            webView?.configuration.userContentController.addUserScript(userScript)
        } else {
            webView?.configuration.userContentController.removeAllUserScripts()
        }
        webView?.reload()
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
