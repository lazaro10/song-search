import Foundation
import Testing
import SwiftData
import SongAPI
@testable import Storage

@MainActor
@Suite struct SwiftDataAlbumCacheTests {
    @Test func fetchReturnsNilWhenEmpty() async throws {
        let sut = try makeSUT()
        let result = await sut.fetch(collectionId: 42)
        #expect(result == nil)
    }

    @Test func saveAndFetchRoundtripsAllFields() async throws {
        let sut = try makeSUT()
        let album = Album(
            id: 100,
            name: "Honky Château",
            artistName: "Elton John",
            releaseYear: 1973,
            trackCount: 10,
            artworkURL: URL(string: "https://example.com/cover.png"),
            songs: [
                Song(id: 1, name: "Daniel", artistName: "Elton John", albumName: "Honky Château", albumId: 100, artworkURL: nil, previewURL: nil, duration: 220),
            ]
        )

        await sut.save(album)
        let result = await sut.fetch(collectionId: 100)

        #expect(result == album)
    }

    @Test func saveOverwritesExistingEntry() async throws {
        let sut = try makeSUT()
        let original = makeAlbum(id: 1, name: "First")
        let updated = makeAlbum(id: 1, name: "Updated")

        await sut.save(original)
        await sut.save(updated)
        let result = await sut.fetch(collectionId: 1)

        #expect(result?.name == "Updated")
    }

    @Test func fetchByCollectionIdReturnsOnlyMatchingAlbum() async throws {
        let sut = try makeSUT()
        await sut.save(makeAlbum(id: 1, name: "Album One"))
        await sut.save(makeAlbum(id: 2, name: "Album Two"))

        let result = await sut.fetch(collectionId: 2)

        #expect(result?.name == "Album Two")
    }

    // MARK: - Helpers

    private func makeSUT() throws -> SwiftDataAlbumCache {
        let container = try StorageContainer.makeInMemory()
        return SwiftDataAlbumCache(container: container)
    }

    private func makeAlbum(id: Int, name: String) -> Album {
        Album(
            id: id,
            name: name,
            artistName: "Artist",
            releaseYear: 2024,
            trackCount: 1,
            artworkURL: nil,
            songs: []
        )
    }
}
