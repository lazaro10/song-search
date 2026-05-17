import Foundation

public protocol SongRepository: Sendable {
    func searchSongs(term: String, limit: Int, offset: Int) async throws -> [Song]
    func songsInAlbum(collectionId: Int) async throws -> [Song]
}
