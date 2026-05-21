import Foundation
import SongAPI

final class AlbumLookupRepositorySpy: AlbumLookupRepository, @unchecked Sendable {
    var stubbedAlbum: Album?
    var errorToThrow: Error?

    private(set) var albumCalls: [Int] = []

    func album(collectionId: Int) async throws -> Album {
        albumCalls.append(collectionId)
        if let error = errorToThrow { throw error }
        guard let album = stubbedAlbum else {
            fatalError("AlbumLookupRepositorySpy.stubbedAlbum was not set")
        }
        return album
    }
}
