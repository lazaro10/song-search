import Foundation

public protocol SongRepository: Sendable {
    func searchSongs(term: String, limit: Int, offset: Int) async throws -> [Song]
    func album(collectionId: Int) async throws -> Album
}
