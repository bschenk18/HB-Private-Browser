import SwiftUI
import WebKit

struct WebViewWrapper: UIViewRepresentable {
    var url: URL
    var webViewState: WebViewState
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewWrapper
        
        init(_ parent: WebViewWrapper) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.webViewState.webView = webView
            parent.webViewState.updateURL(webView.url)
            parent.webViewState.updateCanGoBack(webView.canGoBack)
            parent.webViewState.updateCanGoForward(webView.canGoForward)
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.webViewState.updateCanGoBack(webView.canGoBack)
            parent.webViewState.updateCanGoForward(webView.canGoForward)
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            parent.webViewState.updateURL(navigationAction.request.url)
            decisionHandler(.allow)
        }
    }
}
