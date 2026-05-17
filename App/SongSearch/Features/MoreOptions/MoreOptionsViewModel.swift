import Foundation
import Observation
import SongAPI

@MainActor
@Observable
final class MoreOptionsViewModel {
    let song: Song

    init(song: Song) {
        self.song = song
    }

    var canViewAlbum: Bool {
        song.albumId != nil
    }

    var shareMessage: String {
        "Check out \(song.name) by \(song.artistName)"
    }
}
