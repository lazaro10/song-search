import Foundation
import Testing
import SongAPI
@testable import Storage

@Suite struct UserDefaultsSearchHistoryRepositoryTests {
    @Test func lastSearchReturnsNilWhenStoreIsEmpty() async {
        let sut = makeSUT()
        let result = await sut.lastSearch()
        #expect(result == nil)
    }

    @Test func saveAndLoadRoundtripsSnapshot() async {
        let sut = makeSUT()
        let songs = [
            makeSong(id: 1, name: "Daniel"),
            makeSong(id: 2, name: "Hey Jude"),
        ]

        await sut.save(term: "elton", songs: songs)
        let result = await sut.lastSearch()

        #expect(result?.term == "elton")
        #expect(result?.songs == songs)
    }

    @Test func saveOverwritesPreviousSnapshot() async {
        let sut = makeSUT()

        await sut.save(term: "first", songs: [makeSong(id: 1)])
        await sut.save(term: "second", songs: [makeSong(id: 2)])
        let result = await sut.lastSearch()

        #expect(result?.term == "second")
        #expect(result?.songs.map(\.id) == [2])
    }

    @Test func lastSearchReturnsNilWhenStoredDataIsCorrupt() async {
        let defaults = isolatedUserDefaults()
        defaults.set(Data("not a json".utf8), forKey: "test-key")
        let sut = UserDefaultsSearchHistoryRepository(userDefaults: defaults, key: "test-key")

        let result = await sut.lastSearch()

        #expect(result == nil)
    }

    private func makeSUT(key: String = "test-key") -> UserDefaultsSearchHistoryRepository {
        UserDefaultsSearchHistoryRepository(userDefaults: isolatedUserDefaults(), key: key)
    }

    private func isolatedUserDefaults() -> UserDefaults {
        let suiteName = "test.search.history.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }

    private func makeSong(id: Int = 1, name: String = "Sample") -> Song {
        Song(
            id: id,
            name: name,
            artistName: "Artist",
            albumName: nil,
            albumId: nil,
            artworkURL: nil,
            previewURL: nil,
            duration: 0
        )
    }
}
