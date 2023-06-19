import SwiftUI

struct Bookmark: Identifiable, Equatable, Codable, Hashable {
    var id = UUID()
    var title: String
    var url: URL
    var isFavorite: Bool = false
}

struct BookmarkRow: View {
    var bookmark: Bookmark

    var body: some View {
        HStack {
            if bookmark.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            Text(bookmark.title)
            Spacer()
            Text(bookmark.url.absoluteString)
        }
    }
}

