import Foundation
import Testing
import SongAPI
@testable import SongSearch

@MainActor
@Suite struct HomeViewModelTests {
    @Test func initialStateIsIdle() {
        let (sut, _, _) = makeSUT()
        #expect(sut.state == .idle)
        #expect(sut.searchTerm.isEmpty)
        #expect(sut.recentlyPlayed.isEmpty)
        #expect(sut.isPaginating == false)
    }

    @Test func onAppearLoadsRecentlyPlayed() async {
        let (sut, _, recentRepo) = makeSUT()
        recentRepo.stubbedSongs = [
            SongFixture.make(id: 1),
            SongFixture.make(id: 2),
        ]

        await sut.onAppear()

        #expect(sut.recentlyPlayed.map(\.id) == [1, 2])
        #expect(recentRepo.recentRequests == [10])
    }

    @Test func emptySearchTermLeavesStateIdleWithoutSearching() async {
        let (sut, songRepo, _) = makeSUT()

        sut.searchTerm = "   "
        sut.processSearchTermChange()
        await sut.waitForPendingSearch()

        #expect(sut.state == .idle)
        #expect(songRepo.searchCalls.isEmpty)
    }

    @Test func searchTermChangeTriggersSearchAndPopulatesContent() async {
        let (sut, songRepo, _) = makeSUT()
        songRepo.stubbedSongs = [
            SongFixture.make(id: 1, name: "Yesterday"),
            SongFixture.make(id: 2, name: "Hey Jude"),
        ]

        sut.searchTerm = "beatles"
        sut.processSearchTermChange()
        await sut.waitForPendingSearch()

        #expect(songRepo.searchCalls == [
            SongRepositorySpy.SearchCall(term: "beatles", limit: 20, offset: 0),
        ])
        if case let .content(songs) = sut.state {
            #expect(songs.map(\.id) == [1, 2])
        } else {
            Issue.record("Expected .content, got \(sut.state)")
        }
    }

    @Test func searchTermIsTrimmedBeforeQuerying() async {
        let (sut, songRepo, _) = makeSUT()
        songRepo.stubbedSongs = [SongFixture.make(id: 1)]

        sut.searchTerm = "   beatles   "
        sut.processSearchTermChange()
        await sut.waitForPendingSearch()

        #expect(songRepo.searchCalls.first?.term == "beatles")
    }

    @Test func emptyResultsGoToEmptyState() async {
        let (sut, songRepo, _) = makeSUT()
        songRepo.stubbedSongs = []

        sut.searchTerm = "xyz"
        sut.processSearchTermChange()
        await sut.waitForPendingSearch()

        #expect(sut.state == .empty)
    }

    @Test func failureGoesToErrorState() async {
        let (sut, songRepo, _) = makeSUT()
        songRepo.errorToThrow = SampleError.network

        sut.searchTerm = "anything"
        sut.processSearchTermChange()
        await sut.waitForPendingSearch()

        if case let .error(message) = sut.state {
            #expect(message == SampleError.network.localizedDescription)
        } else {
            Issue.record("Expected .error, got \(sut.state)")
        }
    }

    @Test func loadMoreAppendsResultsWithIncrementedOffset() async {
        let (sut, songRepo, _) = makeSUT(pageSize: 2)
        songRepo.stubbedSongs = [
            SongFixture.make(id: 1),
            SongFixture.make(id: 2),
        ]
        sut.searchTerm = "x"
        sut.processSearchTermChange()
        await sut.waitForPendingSearch()

        songRepo.stubbedSongs = [
            SongFixture.make(id: 3),
            SongFixture.make(id: 4),
        ]
        await sut.loadMoreIfNeeded()

        #expect(songRepo.searchCalls.count == 2)
        #expect(songRepo.searchCalls[1] == .init(term: "x", limit: 2, offset: 2))
        if case let .content(songs) = sut.state {
            #expect(songs.map(\.id) == [1, 2, 3, 4])
        } else {
            Issue.record("Expected .content, got \(sut.state)")
        }
    }

    @Test func loadMoreNoOpsWhenLastPageWasShort() async {
        let (sut, songRepo, _) = makeSUT(pageSize: 5)
        songRepo.stubbedSongs = [SongFixture.make(id: 1)]
        sut.searchTerm = "x"
        sut.processSearchTermChange()
        await sut.waitForPendingSearch()

        let callCountBefore = songRepo.searchCalls.count
        await sut.loadMoreIfNeeded()

        #expect(songRepo.searchCalls.count == callCountBefore)
    }

    @Test func loadMoreNoOpsWhenStateIsNotContent() async {
        let (sut, songRepo, _) = makeSUT()
        await sut.loadMoreIfNeeded()
        #expect(songRepo.searchCalls.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(pageSize: Int = 20) -> (
        sut: HomeViewModel,
        songRepository: SongRepositorySpy,
        recentlyPlayedRepository: RecentlyPlayedRepositorySpy
    ) {
        let songRepo = SongRepositorySpy()
        let recentRepo = RecentlyPlayedRepositorySpy()
        let sut = HomeViewModel(
            songRepository: songRepo,
            recentlyPlayedRepository: recentRepo,
            pageSize: pageSize,
            debounceDuration: .zero
        )
        return (sut, songRepo, recentRepo)
    }
}

private enum SampleError: Error, LocalizedError {
    case network
    var errorDescription: String? { "Sample network error" }
}
