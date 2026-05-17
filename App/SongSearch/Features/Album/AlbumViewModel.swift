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

    func start() async {
        state = .loading
        do {
            let album = try await songRepository.album(collectionId: collectionId)
            state = album.songs.isEmpty ? .empty : .content(album: album)
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }
}
