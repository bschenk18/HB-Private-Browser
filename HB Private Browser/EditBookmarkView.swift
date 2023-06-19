import SwiftUI

struct EditBookmarkView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var bookmark: Bookmark
    @Binding var isEditingBookmark: Bool

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $bookmark.title)
                TextField("URL", text: Binding(
                    get: { self.bookmark.url.absoluteString },
                    set: { self.bookmark.url = URL(string: $0) ?? self.bookmark.url }
                ))
                Toggle(isOn: $bookmark.isFavorite) {
                    Text("Favorite")
                }
            }
            .navigationBarTitle(isEditingBookmark ? "Edit Bookmark" : "New Bookmark", displayMode: .inline)
            .navigationBarItems(leading: Button("Bookmarks") {
                self.presentationMode.wrappedValue.dismiss()
                isEditingBookmark = false
            }.disabled(bookmark.title.isEmpty || bookmark.url.absoluteString.isEmpty)) // Disable button if title or url is empty
            .onTapGesture {
                hideKeyboard() // Hide the keyboard when tapped anywhere within the Form
            }
        }
    }

#if canImport(UIKit)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
#endif
}
