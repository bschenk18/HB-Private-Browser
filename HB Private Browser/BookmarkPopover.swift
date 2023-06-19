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
                        Button("Save") {
                            if !self.title.isEmpty && !self.url.isEmpty {
                                if let url = URL(string: self.url) {
                                    let bookmark = Bookmark(title: self.title, url: url, isFavorite: self.isFavorite)
                                    webViewState.bookmarks.append(bookmark)
                                    self.title = ""
                                    self.url = ""
                                    self.isFavorite = false
                                    BookmarkPersistence.save(webViewState.bookmarks) // Save the updated bookmarks
                                } else {
                                    // Show an error message for invalid URL
                                }
                            } else {
                                // Show an error message for empty fields
                            }
                        }
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
                                }
                            }
                        }
                        .onDelete(perform: delete)
                        .onMove(perform: move)
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
    
    private func delete(at offsets: IndexSet) {
        webViewState.bookmarks.remove(atOffsets: offsets)
        BookmarkPersistence.save(webViewState.bookmarks) // Save the updated bookmarks after deletion
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        webViewState.bookmarks.move(fromOffsets: source, toOffset: destination)
        BookmarkPersistence.save(webViewState.bookmarks) // Save the updated bookmarks after moving
    }

#if canImport(UIKit)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
#endif
}
