import Foundation
import Observation
import SongAPI

@MainActor
@Observable
final class MoreOptionsViewModel {
    let song: Song

    private let recentlyPlayedRepository: RecentlyPlayedRepository

    init(song: Song, recentlyPlayedRepository: RecentlyPlayedRepository) {
        self.song = song
        self.recentlyPlayedRepository = recentlyPlayedRepository
    }

    var canViewAlbum: Bool {
        song.albumId != nil
    }

    var shareMessage: String {
        "Check out \(song.name) by \(song.artistName)"
    }

    func addToRecentlyPlayed() async {
        await recentlyPlayedRepository.add(song)
    }
}
