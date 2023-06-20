import SwiftUI
import WebKit

struct WebViewScreen: View {
    @ObservedObject var webViewState: WebViewState
    @Binding var showWebView: Bool
    @Binding var isFaceIDProtected: Bool
    @Binding var isIncognitoModeOn: Bool
    @Binding var isAutoEncryptionOn: Bool
    @Binding var isSecureStorageOn: Bool
    
    @State private var showingBookmarkPopover = false
    
    let faceIdAuth = FaceIDAuth()
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            if let urlToLoad = webViewState.urlToLoad {
                WebViewWrapper(url: urlToLoad, webViewState: webViewState)
                    .offset(y: 40)
            }
            
            VStack {
                HStack {
                    Button(action: {
                        self.showWebView = false
                    }) {
                        Image(systemName: "house")
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing, 6)
                    
                    TextField("", text: $webViewState.currentURL, onCommit: {
                        webViewState.handleSearch(searchText: webViewState.currentURL)
                    })
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            Button(action: {
                                webViewState.refresh()
                            }) {
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.blue)
                                    .padding(.trailing, 16)
                            }
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 10)
                .background(Color.white)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        webViewState.goBack()
                    }) {
                        Image(systemName: "arrow.left")
                    }
                    .disabled(!webViewState.canGoBack)
                    
                    Spacer()
                    
                    Button(action: {
                        webViewState.goForward()
                    }) {
                        Image(systemName: "arrow.right")
                    }
                    .disabled(!webViewState.canGoForward)
                    
                    Spacer()
                    
                    Button(action: {
                        webViewState.toggleHyperBold()
                    }) {
                        Image(systemName: "bold")
                    }
                    .foregroundColor(webViewState.isHyperBoldEnabled ? .blue : .primary)
                    
                    Spacer()
                    
                    Button(action: {
                        clearAll()
                    }) {
                        Image(systemName: "tornado")
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if isFaceIDProtected {
                            faceIdAuth.authenticateUser { success in
                                if success {
                                    showingBookmarkPopover = true
                                }
                            }
                        } else {
                            showingBookmarkPopover = true
                        }
                    }) {
                        Image(systemName: "bookmark")
                    }
                    .popover(isPresented: $showingBookmarkPopover) {
                        BookmarkPopover(showPopover: $showingBookmarkPopover, webViewState: webViewState)
                    }
                    
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray5))
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
        .environment(\.colorScheme, .light)
    }
    private func clearAll() {
        webViewState.deleteAllCookies()
        webViewState.currentURL = ""
        webViewState.urlToLoad = nil
        
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
