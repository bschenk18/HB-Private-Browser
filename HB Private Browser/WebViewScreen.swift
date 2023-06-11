import SwiftUI
import WebKit

struct WebViewScreen: View {
    @ObservedObject var webViewState: WebViewState
    @State private var showShareSheet = false

    var body: some View {
        VStack {
            HStack {
                TextField("", text: $webViewState.searchText, onCommit: {
                    webViewState.handleSearch(searchText: webViewState.searchText)
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
                                .padding(.trailing, 14)  // Increase trailing padding
                        }
                    }
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    showShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                        .padding(.leading, 8)
                }
                .sheet(isPresented: $showShareSheet) {
                    ShareSheet(items: [webViewState.urlToLoad as Any])
                }
            }
            .padding(.horizontal, 10)

            if let urlToLoad = webViewState.urlToLoad {
                WebViewWrapper(url: urlToLoad, webViewState: webViewState)
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
