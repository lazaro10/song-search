import Foundation
import Testing
import SongAPI
import Storage
@testable import SongSearch

@MainActor
@Suite struct HomeViewModelTests {
    @Test func initialStateDelegatesToIdleSearch() {
        let (sut, _, _, _) = makeSUT()
        #expect(sut.search.state == .idle)
        #expect(sut.search.term.isEmpty)
        #expect(sut.recentlyPlayed.isEmpty)
        #expect(sut.restoredFromCache == false)
    }

    @Test func onAppearLoadsRecentlyPlayed() async {
        let (sut, _, recentRepo, _) = makeSUT()
        recentRepo.stubbedSongs = [
            SongFixture.make(id: 1),
            SongFixture.make(id: 2),
        ]

        await sut.onAppear()

        #expect(sut.recentlyPlayed.map(\.id) == [1, 2])
        #expect(recentRepo.recentRequests == [10])
    }

    @Test func onAppearRestoresLastSearchAndSetsFlag() async {
        let (sut, _, _, historyRepo) = makeSUT()
        historyRepo.stubbedSnapshot = SearchHistorySnapshot(
            term: "beatles",
            songs: [SongFixture.make(id: 1), SongFixture.make(id: 2)]
        )

        await sut.onAppear()

        #expect(sut.search.term.isEmpty)
        #expect(sut.restoredFromCache == true)
        if case let .content(songs) = sut.search.state {
            #expect(songs.map(\.id) == [1, 2])
        } else {
            Issue.record("Expected .content, got \(sut.search.state)")
        }
    }

    @Test func onAppearLeavesFlagFalseWhenCacheIsEmpty() async {
        let (sut, _, _, _) = makeSUT()
        await sut.onAppear()
        #expect(sut.restoredFromCache == false)
        #expect(sut.search.state == .idle)
    }

    @Test func userInputClearsRestoredFromCacheFlag() async {
        let (sut, _, _, historyRepo) = makeSUT()
        historyRepo.stubbedSnapshot = SearchHistorySnapshot(
            term: "beatles",
            songs: [SongFixture.make(id: 1)]
        )
        await sut.onAppear()
        #expect(sut.restoredFromCache == true)

        sut.search.term = "a"
        sut.processSearchTermChange()

        #expect(sut.restoredFromCache == false)
    }

    @Test func successfulSearchPersistsSnapshotThroughCallback() async {
        let (sut, songRepo, _, historyRepo) = makeSUT()
        songRepo.stubbedSongs = [SongFixture.make(id: 1), SongFixture.make(id: 2)]

        sut.search.term = "beatles"
        sut.processSearchTermChange()
        await sut.search.waitForPendingSearch()

        #expect(historyRepo.saveCalls.count == 1)
        #expect(historyRepo.saveCalls.first?.term == "beatles")
        #expect(historyRepo.saveCalls.first?.songs.map(\.id) == [1, 2])
    }

    private func makeSUT() -> (
        sut: HomeViewModel,
        songSearchRepository: SongSearchRepositorySpy,
        recentlyPlayedRepository: RecentlyPlayedRepositorySpy,
        searchHistoryRepository: SearchHistoryRepositorySpy
    ) {
        let songRepo = SongSearchRepositorySpy()
        let recentRepo = RecentlyPlayedRepositorySpy()
        let historyRepo = SearchHistoryRepositorySpy()
        let sut = HomeViewModel(
            songSearchRepository: songRepo,
            recentlyPlayedRepository: recentRepo,
            searchHistoryRepository: historyRepo,
            pageSize: 20,
            debounceDuration: .zero
        )
        return (sut, songRepo, recentRepo, historyRepo)
    }
}
