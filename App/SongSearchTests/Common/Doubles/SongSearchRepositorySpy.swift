import Foundation
import SongAPI

final class SongSearchRepositorySpy: SongSearchRepository, @unchecked Sendable {
    struct SearchCall: Equatable {
        let term: String
        let limit: Int
        let offset: Int
    }

    private(set) var searchCalls: [SearchCall] = []

    var stubbedSongs: [Song] = []
    var errorToThrow: Error?

    func searchSongs(term: String, limit: Int, offset: Int) async throws -> [Song] {
        searchCalls.append(SearchCall(term: term, limit: limit, offset: offset))
        if let error = errorToThrow { throw error }
        return stubbedSongs
    }
}
