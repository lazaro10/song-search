import Foundation
import SongAPI

protocol RecentlyPlayedRepository: Sendable {
    func recentSongs(limit: Int) async -> [Song]
    func add(_ song: Song) async
}

struct StubRecentlyPlayedRepository: RecentlyPlayedRepository {
    func recentSongs(limit: Int) async -> [Song] { [] }
    func add(_ song: Song) async {}
}
