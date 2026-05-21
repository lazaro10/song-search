import Foundation
import Observation
import SongAPI

@MainActor
@Observable
final class AlbumViewModel {
    let collectionId: Int
    private(set) var state: AlbumViewState = .idle

    private let albumLookupRepository: any AlbumLookupRepository

    init(collectionId: Int, albumLookupRepository: any AlbumLookupRepository) {
        self.collectionId = collectionId
        self.albumLookupRepository = albumLookupRepository
    }

    func start() async {
        state = .loading
        do {
            let album = try await albumLookupRepository.album(collectionId: collectionId)
            state = album.songs.isEmpty ? .empty : .content(album: album)
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }
}
