import Foundation
import SongAPI

public final class CachingAlbumLookupRepository: AlbumLookupRepository {
    private let wrapped: any AlbumLookupRepository
    private let albumCache: any AlbumCache

    public init(wrapped: any AlbumLookupRepository, albumCache: any AlbumCache) {
        self.wrapped = wrapped
        self.albumCache = albumCache
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
