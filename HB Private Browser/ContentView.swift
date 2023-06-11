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
                                Image(systemName: incognitoModeOn ? "eye" : "eye.slash")
                                Text("Privacy:")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                    }
                    
                } else {
                    Button(action: {
                        faceIdAuth.authenticateUser { success in
                            isUnlocked = success
                        }
                    }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
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
                .foregroundColor(.white)
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
                    Text("Search")
                        .foregroundColor(.white)
                        .padding(7)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 10)
            }
            .padding()
            
            Spacer()
        }
        .background(Color(red: 0, green: 0, blue: 0.5, opacity: 1)) // Navy Blue
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Privacy: Off"), dismissButton: .default(Text("OK")))
        }
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

