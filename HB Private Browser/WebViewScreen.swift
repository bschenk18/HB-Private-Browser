import SwiftUI

struct WebViewScreen: View {
    @ObservedObject var webViewState: WebViewState
    
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
                            
                            Spacer()
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 10)

            if let urlToLoad = webViewState.urlToLoad {
                WebViewWrapper(url: urlToLoad)
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

