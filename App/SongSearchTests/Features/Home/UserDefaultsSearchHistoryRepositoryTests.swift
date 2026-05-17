import Foundation
import Testing
import SongAPI
@testable import SongSearch

@Suite struct UserDefaultsSearchHistoryRepositoryTests {
    @Test func lastSearchReturnsNilWhenStoreIsEmpty() async {
        let sut = makeSUT()
        let result = await sut.lastSearch()
        #expect(result == nil)
    }

    @Test func saveAndLoadRoundtripsSnapshot() async {
        let sut = makeSUT()
        let songs = [
            SongFixture.make(id: 1, name: "Daniel"),
            SongFixture.make(id: 2, name: "Hey Jude"),
        ]

        await sut.save(term: "elton", songs: songs)
        let result = await sut.lastSearch()

        #expect(result?.term == "elton")
        #expect(result?.songs == songs)
    }

    @Test func saveOverwritesPreviousSnapshot() async {
        let sut = makeSUT()

        await sut.save(term: "first", songs: [SongFixture.make(id: 1)])
        await sut.save(term: "second", songs: [SongFixture.make(id: 2)])
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

    // MARK: - Helpers

    private func makeSUT(key: String = "test-key") -> UserDefaultsSearchHistoryRepository {
        UserDefaultsSearchHistoryRepository(userDefaults: isolatedUserDefaults(), key: key)
    }

    private func isolatedUserDefaults() -> UserDefaults {
        let suiteName = "test.search.history.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}
