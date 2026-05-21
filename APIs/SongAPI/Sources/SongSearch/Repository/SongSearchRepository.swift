import Foundation

public protocol SongSearchRepository: Sendable {
    func searchSongs(term: String, limit: Int, offset: Int) async throws -> [Song]
}
