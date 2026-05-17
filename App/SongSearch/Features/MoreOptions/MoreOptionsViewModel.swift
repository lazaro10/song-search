import Foundation
import Observation
import SongAPI
import Storage

@MainActor
@Observable
final class MoreOptionsViewModel {
    let song: Song

    private let recentlyPlayedRepository: any RecentlyPlayedRepository

    init(song: Song, recentlyPlayedRepository: any RecentlyPlayedRepository) {
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
