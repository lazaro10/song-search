import Foundation
import Observation
import SongAPI

@MainActor
@Observable
final class PlayerViewModel {
    let song: Song
    private(set) var state: PlayerViewState = .idle

    init(song: Song) {
        self.song = song
    }
}
