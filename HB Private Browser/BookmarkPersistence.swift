import Foundation

class BookmarkPersistence {
    private static let bookmarkKey = "bookmarks"

    static func save(_ bookmarks: [Bookmark]) {
        do {
            let data = try JSONEncoder().encode(bookmarks)
            UserDefaults.standard.set(data, forKey: bookmarkKey)
        } catch {
            print("Error encoding bookmarks: \(error)")
        }
    }

    static func load() -> [Bookmark] {
        guard let data = UserDefaults.standard.data(forKey: bookmarkKey) else { return [] }
        do {
            return try JSONDecoder().decode([Bookmark].self, from: data)
        } catch {
            print("Error decoding bookmarks: \(error)")
            return []
        }
    }
}

