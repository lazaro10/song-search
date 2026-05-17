import Foundation
import SongAPI
@testable import Storage

@MainActor
final class AlbumCacheSpy: AlbumCache {
    var stubbedAlbum: Album?
    private(set) var fetchCalls: [Int] = []
    private(set) var saveCalls: [Album] = []

    func fetch(collectionId: Int) async -> Album? {
        fetchCalls.append(collectionId)
        return stubbedAlbum
    }

    func save(_ album: Album) async {
        saveCalls.append(album)
    }
}
