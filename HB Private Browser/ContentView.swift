import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @StateObject private var webViewState = WebViewState(isIncognitoModeOn: true, isDNTEnabled: false, isUserAgentSpoofingEnabled: false)
    @State private var searchText1 = ""
    @State private var isUnlocked = true
    @State private var showWebView = false
    @State private var isIncognitoModeOn: Bool
    @State private var isFaceIDProtected = UserDefaults.standard.bool(forKey: "FaceIDProtectionEnabled")
    @State private var isAutoEncryptionOn: Bool
    @State private var isSecureStorageOn: Bool
    @State private var isFeatureTextAnimating = false
    @State private var showingPopover = false
    @State private var isKeyboardShowing = false
    
    let faceIdAuth = FaceIDAuth()

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        if !isKeyboardShowing {
                            if isFaceIDProtected {
                                faceIdAuth.authenticateUser { success in
                                    if success {
                                        self.showingPopover = true
                                    }
                                }
                            } else {
                                self.showingPopover = true
                            }
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
            .environment(\.colorScheme, .dark)
            .fullScreenCover(isPresented: $showWebView) {
                WebViewScreen(webViewState: webViewState,
                              showWebView: $showWebView,
                              isFaceIDProtected: $isFaceIDProtected,
                              isIncognitoModeOn: $isIncognitoModeOn,
                              isAutoEncryptionOn: $isAutoEncryptionOn,
                              isSecureStorageOn: $isSecureStorageOn)
            }
            .onTapGesture {
                hideKeyboard()
            }
            .onChange(of: isIncognitoModeOn) { newValue in
                UserDefaults.standard.set(newValue, forKey: "IncognitoModeEnabled")
                webViewState.isIncognitoModeOn = newValue
                webViewState.setupWebView()
            }
            .onAppear {
                webViewState.setupWebView()
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (_) in
                    isKeyboardShowing = true
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (_) in
                    isKeyboardShowing = false
                }
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
            .onChange(of: isAutoEncryptionOn) { newValue in
                UserDefaults.standard.set(newValue, forKey: "AutoEncryptionEnabled")
            }
            .onChange(of: isSecureStorageOn) { newValue in
                UserDefaults.standard.set(newValue, forKey: "SecureStorageEnabled")
            }

            if showingPopover {
                SettingsPopoverView(showingPopover: $showingPopover, isFaceIDProtected: $isFaceIDProtected, isIncognitoModeOn: $isIncognitoModeOn, isAutoEncryptionOn: $isAutoEncryptionOn, isSecureStorageOn: $isSecureStorageOn)
            }
            
            MarqueeText()
        }
        .ignoresSafeArea(.keyboard)
    }

    init() {
        let isIncognitoModeEnabled = UserDefaults.standard.bool(forKey: "IncognitoModeEnabled")
        let isAutoEncryptionEnabled = UserDefaults.standard.bool(forKey: "AutoEncryptionEnabled")
        let isSecureStorageEnabled = UserDefaults.standard.bool(forKey: "SecureStorageEnabled")

        if !UserDefaults.standard.bool(forKey: "DefaultsSet") {
            isIncognitoModeOn = true
            isAutoEncryptionOn = true
            isSecureStorageOn = true

            UserDefaults.standard.set(true, forKey: "DefaultsSet")
            UserDefaults.standard.set(true, forKey: "IncognitoModeEnabled")
            UserDefaults.standard.set(true, forKey: "AutoEncryptionEnabled")
            UserDefaults.standard.set(true, forKey: "SecureStorageEnabled")
        } else {
            _isIncognitoModeOn = State(initialValue: isIncognitoModeEnabled)
            _isAutoEncryptionOn = State(initialValue: isAutoEncryptionEnabled)
            _isSecureStorageOn = State(initialValue: isSecureStorageEnabled)
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
