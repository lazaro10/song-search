import Foundation
import SongAPI
import Storage

@MainActor
final class RecentlyPlayedRepositorySpy: RecentlyPlayedRepository {
    var stubbedSongs: [Song] = []
    private(set) var addCalls: [Song] = []
    private(set) var recentRequests: [Int] = []

    func recentSongs(limit: Int) async -> [Song] {
        recentRequests.append(limit)
        return Array(stubbedSongs.prefix(limit))
    }

    func add(_ song: Song) async {
        addCalls.append(song)
    }
}
