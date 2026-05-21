import Foundation
import Testing
import SongAPI
@testable import Storage

@MainActor
@Suite struct CachingSongRepositoryTests {
    @Test func searchSongsPassesThroughToWrappedRepository() async throws {
        let wrapped = SongRepositorySpy()
        wrapped.stubbedSongs = [makeSong(id: 1), makeSong(id: 2)]
        let sut = CachingSongRepository(wrapped: wrapped, albumCache: AlbumCacheSpy())

        let result = try await sut.searchSongs(term: "beatles", limit: 20, offset: 40)

        #expect(result.map(\.id) == [1, 2])
        #expect(wrapped.searchCalls.count == 1)
        #expect(wrapped.searchCalls.first?.term == "beatles")
        #expect(wrapped.searchCalls.first?.limit == 20)
        #expect(wrapped.searchCalls.first?.offset == 40)
    }

    @Test func albumOnNetworkSuccessSavesToCacheAndReturnsFresh() async throws {
        let wrapped = SongRepositorySpy()
        let cache = AlbumCacheSpy()
        let fresh = makeAlbum(id: 12345, name: "Fresh")
        wrapped.stubbedAlbum = fresh
        let sut = CachingSongRepository(wrapped: wrapped, albumCache: cache)

        let result = try await sut.album(collectionId: 12345)

        #expect(result == fresh)
        #expect(cache.saveCalls.map(\.id) == [12345])
        #expect(cache.fetchCalls.isEmpty)
    }

    @Test func albumOnNetworkFailureReturnsCachedWhenAvailable() async throws {
        let wrapped = SongRepositorySpy()
        wrapped.errorToThrow = CachingTestError.offline
        let cache = AlbumCacheSpy()
        let cached = makeAlbum(id: 7, name: "Cached")
        cache.stubbedAlbum = cached
        let sut = CachingSongRepository(wrapped: wrapped, albumCache: cache)

        let result = try await sut.album(collectionId: 7)

        #expect(result == cached)
        #expect(cache.fetchCalls == [7])
        #expect(cache.saveCalls.isEmpty)
    }

    @Test func albumOnNetworkFailureWithEmptyCacheThrowsOriginalError() async {
        let wrapped = SongRepositorySpy()
        wrapped.errorToThrow = CachingTestError.offline
        let cache = AlbumCacheSpy()
        let sut = CachingSongRepository(wrapped: wrapped, albumCache: cache)

        await #expect(throws: CachingTestError.offline) {
            _ = try await sut.album(collectionId: 999)
        }
        #expect(cache.fetchCalls == [999])
    }

    // MARK: - Helpers

    private func makeSong(id: Int) -> Song {
        Song(
            id: id, name: "Song \(id)", artistName: "Artist",
            albumName: nil, albumId: nil,
            artworkURL: nil, previewURL: nil, duration: 0
        )
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
