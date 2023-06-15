import SwiftUI

struct ContentView: View {
    @StateObject private var webViewState = WebViewState()
    @State private var searchText1 = ""
    @State private var searchText2 = ""
    @State private var isUnlocked = true
    @State private var showAlert = false
    @State private var showWebView = false
    @State private var isIncognitoModeOn = false // Added state for incognito mode
    
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
                            self.isIncognitoModeOn.toggle()
                            if !self.isIncognitoModeOn {
                                self.showAlert = true
                            }
                        }) {
                            HStack {
                                Image(systemName: isIncognitoModeOn ? "eye.fill" : "eye.slash.fill")
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
            
            HStack {
                Spacer()
                
                HStack{
                    
                    // Title Text
                    Text("Private Browser")
                        .font(.title).bold()
                        .foregroundColor(.primary)
                        .padding(.leading, 10) // Add gap between icon and text
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
            }
            .padding(.bottom, -15) // Adjust vertical padding here

            // Second Search Bar with Button
            HStack {
                TextField("", text: $searchText2, onCommit: {
                    handleSearch(searchText: searchText2)
                })
                .padding(7)
                .padding(.horizontal, 5)
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
            WebViewScreen(webViewState: webViewState, showWebView: $showWebView) // <- pass showWebView state
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onChange(of: isIncognitoModeOn) { newValue in
            webViewState.isIncognitoModeOn = newValue
            webViewState.setupWebView()
        }
        .onAppear {
            webViewState.setupWebView()
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
