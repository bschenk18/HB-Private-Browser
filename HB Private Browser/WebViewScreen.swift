import SwiftUI
import WebKit

struct WebViewScreen: View {
   @ObservedObject var webViewState: WebViewState
   @State private var showNewWebViewScreen = false
    @Binding var showWebView: Bool // <- Here is the new binding

   var body: some View {
       VStack {
           HStack {
               
               // Home Button
                              Button(action: {
                                  self.showWebView = false // <- Dismiss the WebViewScreen
                              }) {
                                  Image(systemName: "house")
                                      .foregroundColor(.blue)
                              }
                              .padding(.trailing, 6)
               
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
                               .padding(.trailing, 16)
                       }
                   }
               )
               .frame(maxWidth: .infinity, alignment: .leading)

           }
           .padding(.horizontal, 10)

           Spacer()

           if let urlToLoad = webViewState.urlToLoad {
               WebViewWrapper(url: urlToLoad, webViewState: webViewState)
           }

           Spacer()

           HStack {
               Button(action: {
                   webViewState.goBack()
               }) {
                   Image(systemName: "arrow.left")
               }

               Spacer()
               
               Button(action: {
                   webViewState.goForward()
               }) {
                   Image(systemName: "arrow.right")
               }

               Spacer()
               
               // Use your image here
               Image(systemName: "bold")
                   .foregroundColor(.primary)
           }
           .padding(.horizontal, 20)
           .padding(.vertical, 10)  // Add vertical padding here
           .frame(maxWidth: .infinity)
           .background(Color(.systemGray5))
       }
       .navigationBarHidden(true)
       .onTapGesture {
           hideKeyboard()
       }
       .environment(\.colorScheme, .light) // Always light mode for WebViewScreen
   }

   func hideKeyboard() {
       UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
   }
   
}
