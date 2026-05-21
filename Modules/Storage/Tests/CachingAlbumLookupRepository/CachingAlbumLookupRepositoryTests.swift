import Foundation
import Testing
import SongAPI
@testable import Storage

@MainActor
@Suite struct CachingAlbumLookupRepositoryTests {
    @Test func albumOnNetworkSuccessSavesToCacheAndReturnsFresh() async throws {
        let wrapped = AlbumLookupRepositorySpy()
        let cache = AlbumCacheSpy()
        let fresh = makeAlbum(id: 12345, name: "Fresh")
        wrapped.stubbedAlbum = fresh
        let sut = CachingAlbumLookupRepository(wrapped: wrapped, albumCache: cache)

        let result = try await sut.album(collectionId: 12345)

        #expect(result == fresh)
        #expect(cache.saveCalls.map(\.id) == [12345])
        #expect(cache.fetchCalls.isEmpty)
    }

    @Test func albumOnNetworkFailureReturnsCachedWhenAvailable() async throws {
        let wrapped = AlbumLookupRepositorySpy()
        wrapped.errorToThrow = CachingTestError.offline
        let cache = AlbumCacheSpy()
        let cached = makeAlbum(id: 7, name: "Cached")
        cache.stubbedAlbum = cached
        let sut = CachingAlbumLookupRepository(wrapped: wrapped, albumCache: cache)

        let result = try await sut.album(collectionId: 7)

        #expect(result == cached)
        #expect(cache.fetchCalls == [7])
        #expect(cache.saveCalls.isEmpty)
    }

    @Test func albumOnNetworkFailureWithEmptyCacheThrowsOriginalError() async {
        let wrapped = AlbumLookupRepositorySpy()
        wrapped.errorToThrow = CachingTestError.offline
        let cache = AlbumCacheSpy()
        let sut = CachingAlbumLookupRepository(wrapped: wrapped, albumCache: cache)

        await #expect(throws: CachingTestError.offline) {
            _ = try await sut.album(collectionId: 999)
        }
        #expect(cache.fetchCalls == [999])
    }

    private func makeAlbum(id: Int, name: String) -> Album {
        Album(
            id: id, name: name, artistName: "Artist",
            releaseYear: 2024, trackCount: 1,
            artworkURL: nil, songs: []
        )
    }
}

private enum CachingTestError: Error, Equatable {
    case offline
}
