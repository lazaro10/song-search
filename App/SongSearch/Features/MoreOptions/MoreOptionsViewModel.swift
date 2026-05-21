import Foundation
import Observation
import Localization
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
        L10n.MoreOptions.shareMessage(songName: song.name, artistName: song.artistName)
    }
}
