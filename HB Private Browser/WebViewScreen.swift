import SwiftUI
import WebKit

struct WebViewScreen: View {
   @ObservedObject var webViewState: WebViewState
   @State private var showShareSheet = false
   @State private var showNewWebViewScreen = false

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
                               .padding(.trailing, 16)
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

               Spacer()
            
               Menu {
                   Button(action: {
                       // Create New WebViewScreen
                       self.showNewWebViewScreen.toggle()
                   }) {
                       HStack {
                           Image(systemName: "plus")
                           Text("New")
                       }
                   }
                   
                   Button(action: {
                       // Share current URL
                       showShareSheet = true
                   }) {
                       HStack {
                           Image(systemName: "square.and.arrow.up")
                           Text("Share")
                       }
                   }
                   .sheet(isPresented: $showShareSheet) {
                       ShareSheet(items: [webViewState.urlToLoad as Any])
                   }
                   
                   Button(action: {
                       // Copy current URL
                       if let url = webViewState.urlToLoad {
                               UIPasteboard.general.string = url.absoluteString
                           }
                   }) {
                       HStack {
                           Image(systemName: "doc.on.doc")
                           Text("Copy URL")
                       }
                   }
                   
                   
               } label: {
                   Image(systemName: "ellipsis")
               }
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

   }

   func hideKeyboard() {
       UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
   }
   
}
