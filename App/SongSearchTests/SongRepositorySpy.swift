import Foundation
import SongAPI

final class SongRepositorySpy: SongRepository, @unchecked Sendable {
    struct SearchCall: Equatable {
        let term: String
        let limit: Int
        let offset: Int
    }

    private(set) var searchCalls: [SearchCall] = []
    private(set) var albumCalls: [Int] = []

    var stubbedSongs: [Song] = []
    var stubbedAlbumSongs: [Song] = []
    var errorToThrow: Error?

    func searchSongs(term: String, limit: Int, offset: Int) async throws -> [Song] {
        searchCalls.append(SearchCall(term: term, limit: limit, offset: offset))
        if let error = errorToThrow { throw error }
        return stubbedSongs
    }

    func songsInAlbum(collectionId: Int) async throws -> [Song] {
        albumCalls.append(collectionId)
        if let error = errorToThrow { throw error }
        return stubbedAlbumSongs
    }
}
