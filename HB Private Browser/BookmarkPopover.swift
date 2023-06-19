import SwiftUI

struct BookmarkPopover: View {
    @Binding var showPopover: Bool
    @State var title: String = ""
    @State var url: String = ""
    @State var isFavorite: Bool = false
    @ObservedObject var webViewState: WebViewState
    
    @State private var editMode: EditMode = .inactive
    @State private var activeBookmark: Bookmark? = nil
    @State private var isEditingBookmark = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("New Bookmark")) {
                        TextField("Title", text: $title)
                        TextField("URL", text: $url)
                            .onAppear {
                                self.url = webViewState.currentURL // Autofill the URL field
                            }
                        Toggle(isOn: $isFavorite) {
                            Text("Favorite")
                        }
                        Button(action: {
                            if !self.title.isEmpty && !self.url.isEmpty {
                                if let url = URL(string: self.url) {
                                    let bookmark = Bookmark(title: self.title, url: url, isFavorite: self.isFavorite)
                                    webViewState.bookmarks.append(bookmark)
                                    self.title = ""
                                    self.url = ""
                                    self.isFavorite = false
                                } else {
                                    print("Error: Invalid URL")
                                }
                            } else {
                                print("Error: Title or URL is empty")
                            }
                        }) {
                            Text("Save")
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(self.title.isEmpty || self.url.isEmpty) // Disable button if title or URL is empty
                    }
                    
                    Section(header: Text("Saved Bookmarks")) {
                        ForEach(webViewState.bookmarks.sorted { $0.isFavorite && !$1.isFavorite }) { bookmark in
                            HStack {
                                if bookmark.isFavorite {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                                if editMode == .inactive {
                                    Button(action: {
                                        webViewState.urlToLoad = bookmark.url
                                        showPopover = false
                                    }) {
                                        Text(bookmark.title)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                } else {
                                    Text(bookmark.title)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .onTapGesture {
                                            activeBookmark = bookmark
                                            isEditingBookmark = true
                                        }
                                    // Added chevron icon when edit mode is active
                                    Image(systemName: "chevron.right")
                                        .opacity(editMode == .active ? 1 : 0)
                                    
                                    Spacer()
                                    
                                    // Add a trash button for delete on a single tap
                                    Button(action: {
                                        deleteBookmark(bookmark)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    
                }
                .listStyle(GroupedListStyle())
                .environment(\.editMode, $editMode)
                
                HStack {
                    Button("Done") {
                        self.showPopover = false
                    }
                    
                    Spacer()
                    
                    Button(editMode == .active ? "Done Editing" : "Edit") {
                        if editMode == .active {
                            isEditingBookmark = false
                            activeBookmark = nil
                        }
                        self.editMode = self.editMode == .active ? .inactive : .active
                    }
                }
                .padding()
            }
            .navigationTitle("Bookmarks")
            .sheet(item: $activeBookmark) { bookmark in
                EditBookmarkView(bookmark: $webViewState.bookmarks[webViewState.bookmarks.firstIndex(where: {$0.id == bookmark.id})!], isEditingBookmark: $isEditingBookmark)
            }
        }
        .onTapGesture {
            hideKeyboard() // Hide the keyboard when tapped anywhere within the NavigationView
        }
    }
    
    func deleteBookmark(_ bookmark: Bookmark) {
        guard let index = webViewState.bookmarks.firstIndex(where: { $0.id == bookmark.id }) else { return }
        webViewState.bookmarks.remove(at: index)
    }
    
    
    
    private func move(from source: IndexSet, to destination: Int) {
        webViewState.bookmarks.move(fromOffsets: source, toOffset: destination)
        BookmarkPersistence.save(webViewState.bookmarks) // Save the updated bookmarks after deletion
    }
    
#if canImport(UIKit)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
#endif
}
