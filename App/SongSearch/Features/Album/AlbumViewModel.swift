import Foundation
import Observation
import SongAPI

@MainActor
@Observable
final class AlbumViewModel {
    let collectionId: Int
    private(set) var state: AlbumViewState = .idle

    private let songRepository: SongRepository

    init(collectionId: Int, songRepository: SongRepository) {
        self.collectionId = collectionId
        self.songRepository = songRepository
    }
}
