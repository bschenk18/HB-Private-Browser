import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @StateObject private var webViewState = WebViewState()
    @State private var searchText1 = ""
    @State private var isUnlocked = true
    @State private var showWebView = false
    @State private var isIncognitoModeOn = true
    @State private var isFaceIDProtected = UserDefaults.standard.bool(forKey: "FaceIDProtectionEnabled")
    
    @State private var showingPopover = false
    
    let faceIdAuth = FaceIDAuth()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        if isFaceIDProtected {
                            faceIdAuth.authenticateUser { success in
                                if success {
                                    self.showingPopover = true
                                }
                            }
                        } else {
                            self.showingPopover = true
                        }
                    }) {
                        Image(systemName: "ellipsis.circle.fill")
                            .foregroundColor(.primary)
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
            }
            .background(Color(.systemBackground))
            // .alert() removed
            .environment(\.colorScheme, .dark)
            .fullScreenCover(isPresented: $showWebView) {
                WebViewScreen(webViewState: webViewState, showWebView: $showWebView)
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
            .onChange(of: isFaceIDProtected) { newValue in
                UserDefaults.standard.set(newValue, forKey: "FaceIDProtectionEnabled")
                if newValue {
                    faceIdAuth.authenticateUser { success in
                        if !success {
                            isFaceIDProtected = false
                        }
                    }
                }
            }
            
            if showingPopover {
                VStack {
                    Spacer()
                    
                    VStack {
                        HStack {
                            Text("Face ID:")
                            Spacer()
                            Toggle("", isOn: $isFaceIDProtected)
                                .toggleStyle(SwitchToggleStyle(tint: .blue))
                                .labelsHidden()
                        }.padding()
                        
                        Divider()
                        
                        HStack {
                            Text("Privacy:")
                            Spacer()
                            Button(action: {
                                self.isIncognitoModeOn.toggle()
                            }) {
                                Image(systemName: isIncognitoModeOn ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(.primary)
                            }
                        }.padding()
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .frame(maxHeight: UIScreen.main.bounds.height / 3)
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom))
                }
                .background(Color.gray.opacity(0.1).onTapGesture {
                    self.showingPopover = false
                })
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    func handleSearch(searchText: String) {
        webViewState.handleSearch(searchText: searchText)
        showWebView = true
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
