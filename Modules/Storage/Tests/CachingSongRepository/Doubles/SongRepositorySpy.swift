import Foundation
import SongAPI

final class SongRepositorySpy: SongRepository, @unchecked Sendable {
    var stubbedSongs: [Song] = []
    var stubbedAlbum: Album?
    var errorToThrow: Error?

    private(set) var searchCalls: [(term: String, limit: Int, offset: Int)] = []
    private(set) var albumCalls: [Int] = []

    func searchSongs(term: String, limit: Int, offset: Int) async throws -> [Song] {
        searchCalls.append((term, limit, offset))
        if let error = errorToThrow { throw error }
        return stubbedSongs
    }

    func album(collectionId: Int) async throws -> Album {
        albumCalls.append(collectionId)
        if let error = errorToThrow { throw error }
        guard let album = stubbedAlbum else {
            fatalError("SongRepositorySpy.stubbedAlbum was not set")
        }
        return album
    }
}
