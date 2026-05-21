import Foundation
import SongAPI

/// Decorates an `AlbumLookupRepository`. On a successful network fetch it
/// persists the album to the cache and returns the fresh copy. On failure it
/// falls back to the cached copy when present, otherwise rethrows the
/// original error.
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
