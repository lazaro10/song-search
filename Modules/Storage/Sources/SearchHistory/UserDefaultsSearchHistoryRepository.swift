import Foundation
import SongAPI

public final class UserDefaultsSearchHistoryRepository: SearchHistoryRepository, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let key: String

    public init(userDefaults: UserDefaults = .standard, key: String = "song-search.history.last") {
        self.userDefaults = userDefaults
        self.key = key
    }

    public func lastSearch() async -> SearchHistorySnapshot? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(SearchHistorySnapshot.self, from: data)
    }

    public func save(term: String, songs: [Song]) async {
        let snapshot = SearchHistorySnapshot(term: term, songs: songs)
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        userDefaults.set(data, forKey: key)
    }
}
