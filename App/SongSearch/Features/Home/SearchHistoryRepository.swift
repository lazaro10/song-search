import Foundation
import SongAPI

struct SearchHistorySnapshot: Codable, Sendable, Equatable {
    let term: String
    let songs: [Song]
}

protocol SearchHistoryRepository: Sendable {
    func lastSearch() async -> SearchHistorySnapshot?
    func save(term: String, songs: [Song]) async
}

final class UserDefaultsSearchHistoryRepository: SearchHistoryRepository, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let key: String

    init(userDefaults: UserDefaults = .standard, key: String = "song-search.history.last") {
        self.userDefaults = userDefaults
        self.key = key
    }

    func lastSearch() async -> SearchHistorySnapshot? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(SearchHistorySnapshot.self, from: data)
    }

    func save(term: String, songs: [Song]) async {
        let snapshot = SearchHistorySnapshot(term: term, songs: songs)
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        userDefaults.set(data, forKey: key)
    }
}
