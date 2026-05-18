import Foundation
import SongAPI

public struct SearchHistorySnapshot: Codable, Sendable, Equatable {
    public let term: String
    public let songs: [Song]

    public init(term: String, songs: [Song]) {
        self.term = term
        self.songs = songs
    }
}

public protocol SearchHistoryRepository: Sendable {
    func lastSearch() async -> SearchHistorySnapshot?
    func save(term: String, songs: [Song]) async
}
