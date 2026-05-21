import Foundation
import Testing
import SwiftData
import SongAPI
@testable import Storage

@MainActor
@Suite struct SwiftDataRecentlyPlayedRepositoryTests {
    @Test func recentSongsReturnsEmptyForFreshStore() async throws {
        let sut = try makeSUT()
        let result = await sut.recentSongs(limit: 10)
        #expect(result.isEmpty)
    }

    @Test func addingStoresSongAndRecentSongsReturnsIt() async throws {
        let sut = try makeSUT()
        let song = makeSong(id: 1, name: "Daniel")

        await sut.add(song)
        let result = await sut.recentSongs(limit: 10)

        #expect(result.map(\.id) == [1])
        #expect(result.first?.name == "Daniel")
    }

    @Test func recentSongsReturnsInReverseChronologicalOrder() async throws {
        let sut = try makeSUT()
        await sut.add(makeSong(id: 1))
        try await Task.sleep(for: .milliseconds(10))
        await sut.add(makeSong(id: 2))
        try await Task.sleep(for: .milliseconds(10))
        await sut.add(makeSong(id: 3))

        let result = await sut.recentSongs(limit: 10)

        #expect(result.map(\.id) == [3, 2, 1])
    }

    @Test func reAddingExistingSongMovesItToTop() async throws {
        let sut = try makeSUT()
        await sut.add(makeSong(id: 1))
        try await Task.sleep(for: .milliseconds(10))
        await sut.add(makeSong(id: 2))
        try await Task.sleep(for: .milliseconds(10))
        await sut.add(makeSong(id: 1))

        let result = await sut.recentSongs(limit: 10)

        #expect(result.map(\.id) == [1, 2])
    }

    @Test func addingPastCapEvictsOldestEntries() async throws {
        let sut = try makeSUT(maxItems: 3)
        for id in 1...5 {
            await sut.add(makeSong(id: id))
            try await Task.sleep(for: .milliseconds(5))
        }

        let result = await sut.recentSongs(limit: 10)

        #expect(result.map(\.id) == [5, 4, 3])
    }

    @Test func recentSongsRespectsLimitParameter() async throws {
        let sut = try makeSUT()
        for id in 1...5 {
            await sut.add(makeSong(id: id))
            try await Task.sleep(for: .milliseconds(5))
        }

        let result = await sut.recentSongs(limit: 2)

        #expect(result.map(\.id) == [5, 4])
    }

    private func makeSUT(maxItems: Int = 20) throws -> SwiftDataRecentlyPlayedRepository {
        let container = try StorageContainer.makeInMemory()
        return SwiftDataRecentlyPlayedRepository(container: container, maxItems: maxItems)
    }

    private func makeSong(
        id: Int,
        name: String = "Song",
        artistName: String = "Artist"
    ) -> Song {
        Song(
            id: id,
            name: name,
            artistName: artistName,
            albumName: "Album",
            albumId: 100,
            artworkURL: nil,
            previewURL: nil,
            duration: 180
        )
    }
}
