import Foundation
import SongAPI

public final class CachingSongRepository: SongRepository {
    private let wrapped: any SongRepository
    private let albumCache: any AlbumCache

    public init(wrapped: any SongRepository, albumCache: any AlbumCache) {
        self.wrapped = wrapped
        self.albumCache = albumCache
    }

    public func searchSongs(term: String, limit: Int, offset: Int) async throws -> [Song] {
        try await wrapped.searchSongs(term: term, limit: limit, offset: offset)
    }

    public func album(collectionId: Int) async throws -> Album {
        do {
            let fresh = try await wrapped.album(collectionId: collectionId)
            await albumCache.save(fresh)
            return fresh
        } catch {
            if let cached = await albumCache.fetch(collectionId: collectionId) {
                return cached
            }
            throw error
        }
    }
}
