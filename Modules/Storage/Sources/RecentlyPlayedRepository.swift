import Foundation
import SongAPI

@MainActor
public protocol RecentlyPlayedRepository {
    func recentSongs(limit: Int) async -> [Song]
    func add(_ song: Song) async
}
