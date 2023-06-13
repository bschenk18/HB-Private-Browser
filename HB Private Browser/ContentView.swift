import SwiftUI

struct ContentView: View {
   @StateObject private var webViewState = WebViewState()
   @State private var searchText1 = ""
   @State private var searchText2 = ""
   @State private var isUnlocked = true
   @State private var incognitoModeOn = false
   @State private var showAlert = false
   @State private var showWebView = false
   let faceIdAuth = FaceIDAuth()
   
   func handleSearch(searchText: String) {
       webViewState.handleSearch(searchText: searchText)
       showWebView = true
   }
   
   var body: some View {
       VStack {
           HStack {
               if isUnlocked {
                   Menu {
                       Button(action: {
                           self.incognitoModeOn.toggle()
                           if !self.incognitoModeOn {
                               self.showAlert = true
                           }
                       }) {
                           HStack {
                               Image(systemName: incognitoModeOn ? "eye.fill" : "eye.slash.fill")
                                   .foregroundColor(.primary)
                               Text("Privacy:")
                           }
                       }
                   } label: {
                       Image(systemName: "ellipsis.circle.fill")
                           .foregroundColor(.primary)
                   }
                   
               } else {
                   Button(action: {
                       faceIdAuth.authenticateUser { success in
                           isUnlocked = success
                       }
                   }) {
                       Image(systemName: "ellipsis.circle.fill")
                           .foregroundColor(.primary)
                   }
               }
               Spacer()
               
               // First Search Bar
               TextField("Search", text: $searchText1, onCommit: {
                   handleSearch(searchText: searchText1)
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
                   .padding(.horizontal, 10)
           }.padding()
           
           Spacer()
           
           // Title Text
           Text("HyperBold Private Browser")
               .font(.title)
               .foregroundColor(.primary)
               .padding(7)
               .padding(.horizontal, 10)
               .frame(maxWidth: .infinity, alignment: .leading)
           
           // Second Search Bar with Button
           HStack {
               TextField("", text: $searchText2, onCommit: {
                   handleSearch(searchText: searchText2)
               })
                   .padding(7)
                   .padding(.horizontal, 25)
                   .background(Color(.systemGray6))
                   .cornerRadius(8)
                   .frame(maxWidth: .infinity, alignment: .leading)
               
               Button(action: {
                   handleSearch(searchText: searchText2)
               }) {
                   Image(systemName: "magnifyingglass")
                       .foregroundColor(.primary)
                       .padding(7)
                       .background(Color.blue)
                       .cornerRadius(8)
               }
               .padding(.horizontal, 10)
           }
           .padding()
           
           Spacer()
       }
       .background(Color(.systemBackground)) // Background color adaptable to light/dark mode
       .alert(isPresented: $showAlert) {
           Alert(title: Text("Privacy: Off"), dismissButton: .default(Text("OK")))
       }
       .environment(\.colorScheme, .dark) // Always dark mode for ContentView
       .fullScreenCover(isPresented: $showWebView) {
              WebViewScreen(webViewState: webViewState)
          }
       .onTapGesture {
           hideKeyboard()
       }
   }
   
   func hideKeyboard() {
       UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
   }
}
