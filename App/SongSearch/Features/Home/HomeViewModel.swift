import Foundation
import Observation
import SongAPI

@MainActor
@Observable
final class HomeViewModel {
    private(set) var state: HomeViewState = .idle
    var searchTerm: String = ""

    private let songRepository: SongRepository

    init(songRepository: SongRepository) {
        self.songRepository = songRepository
    }
}
