import Foundation
import Testing
import SongAPI
@testable import SongSearch

@MainActor
@Suite struct SongSearchPaginationTests {
    @Test func initialStateIsIdle() {
        let (sut, _) = makeSUT()
        #expect(sut.state == .idle)
        #expect(sut.term.isEmpty)
        #expect(sut.isPaginating == false)
    }

    @Test func emptyTermLeavesStateIdleWithoutSearching() async {
        let (sut, repo) = makeSUT()
        sut.term = "   "
        sut.processTermChange()
        await sut.waitForPendingSearch()

        #expect(sut.state == .idle)
        #expect(repo.searchCalls.isEmpty)
    }

    @Test func termIsTrimmedBeforeQuerying() async {
        let (sut, repo) = makeSUT()
        repo.stubbedSongs = [SongFixture.make(id: 1)]
        sut.term = "   beatles   "
        sut.processTermChange()
        await sut.waitForPendingSearch()

        #expect(repo.searchCalls.first?.term == "beatles")
    }

    @Test func termChangeTriggersSearchAndPopulatesContent() async {
        let (sut, repo) = makeSUT()
        repo.stubbedSongs = [
            SongFixture.make(id: 1, name: "Yesterday"),
            SongFixture.make(id: 2, name: "Hey Jude"),
        ]

        sut.term = "beatles"
        sut.processTermChange()
        await sut.waitForPendingSearch()

        #expect(repo.searchCalls == [
            SongRepositorySpy.SearchCall(term: "beatles", limit: 20, offset: 0),
        ])
        if case let .content(songs) = sut.state {
            #expect(songs.map(\.id) == [1, 2])
        } else {
            Issue.record("Expected .content, got \(sut.state)")
        }
    }

    @Test func emptyResultsGoToEmptyState() async {
        let (sut, repo) = makeSUT()
        repo.stubbedSongs = []

        sut.term = "xyz"
        sut.processTermChange()
        await sut.waitForPendingSearch()

        #expect(sut.state == .empty)
    }

    @Test func failureGoesToErrorState() async {
        let (sut, repo) = makeSUT()
        repo.errorToThrow = SampleError.network

        sut.term = "x"
        sut.processTermChange()
        await sut.waitForPendingSearch()

        if case let .error(message) = sut.state {
            #expect(message == SampleError.network.localizedDescription)
        } else {
            Issue.record("Expected .error, got \(sut.state)")
        }
    }

    @Test func loadMoreAppendsResultsWithIncrementedOffset() async {
        let (sut, repo) = makeSUT(pageSize: 2)
        repo.stubbedSongs = [
            SongFixture.make(id: 1),
            SongFixture.make(id: 2),
        ]
        sut.term = "x"
        sut.processTermChange()
        await sut.waitForPendingSearch()

        repo.stubbedSongs = [
            SongFixture.make(id: 3),
            SongFixture.make(id: 4),
        ]
        await sut.loadMoreIfNeeded()

        #expect(repo.searchCalls.count == 2)
        #expect(repo.searchCalls[1] == .init(term: "x", limit: 2, offset: 2))
        if case let .content(songs) = sut.state {
            #expect(songs.map(\.id) == [1, 2, 3, 4])
        } else {
            Issue.record("Expected .content, got \(sut.state)")
        }
    }

    @Test func loadMoreNoOpsWhenLastPageWasShort() async {
        let (sut, repo) = makeSUT(pageSize: 5)
        repo.stubbedSongs = [SongFixture.make(id: 1)]
        sut.term = "x"
        sut.processTermChange()
        await sut.waitForPendingSearch()

        let callsBefore = repo.searchCalls.count
        await sut.loadMoreIfNeeded()

        #expect(repo.searchCalls.count == callsBefore)
    }

    @Test func loadMoreNoOpsWhenStateIsNotContent() async {
        let (sut, repo) = makeSUT()
        await sut.loadMoreIfNeeded()
        #expect(repo.searchCalls.isEmpty)
    }

    @Test func loadMoreSilentlyKeepsExistingContentOnFailure() async {
        let (sut, repo) = makeSUT(pageSize: 2)
        repo.stubbedSongs = [
            SongFixture.make(id: 1),
            SongFixture.make(id: 2),
        ]
        sut.term = "x"
        sut.processTermChange()
        await sut.waitForPendingSearch()

        repo.stubbedSongs = []
        repo.errorToThrow = SampleError.network
        await sut.loadMoreIfNeeded()

        if case let .content(songs) = sut.state {
            #expect(songs.map(\.id) == [1, 2])
        } else {
            Issue.record("Expected .content to remain, got \(sut.state)")
        }
    }

    @Test func retryReRunsLastSearchFromOffsetZero() async {
        let (sut, repo) = makeSUT()
        repo.errorToThrow = SampleError.network
        sut.term = "beatles"
        sut.processTermChange()
        await sut.waitForPendingSearch()
        #expect({ if case .error = sut.state { return true }; return false }())

        repo.errorToThrow = nil
        repo.stubbedSongs = [SongFixture.make(id: 1)]
        await sut.retry()

        #expect(repo.searchCalls.last == .init(term: "beatles", limit: 20, offset: 0))
        if case let .content(songs) = sut.state {
            #expect(songs.map(\.id) == [1])
        } else {
            Issue.record("Expected .content, got \(sut.state)")
        }
    }

    @Test func retryNoOpsWhenTermIsEmpty() async {
        let (sut, repo) = makeSUT()
        await sut.retry()
        #expect(repo.searchCalls.isEmpty)
    }

    @Test func seedFromCacheSetsContentAndDisablesPagination() async {
        let (sut, repo) = makeSUT()
        let songs = [SongFixture.make(id: 1), SongFixture.make(id: 2)]

        sut.seedFromCache(songs: songs)
        await sut.loadMoreIfNeeded()

        if case let .content(state) = sut.state {
            #expect(state.map(\.id) == [1, 2])
        } else {
            Issue.record("Expected .content from seed, got \(sut.state)")
        }
        #expect(repo.searchCalls.isEmpty)
    }

    @Test func seedFromCacheIsIgnoredWhenTermIsNotEmpty() {
        let (sut, _) = makeSUT()
        sut.term = "active query"
        sut.seedFromCache(songs: [SongFixture.make(id: 1)])

        #expect(sut.state == .idle)
    }

    @Test func onInitialPageLoadedCallbackIsInvokedOnSuccess() async {
        var captured: [(term: String, ids: [Int])] = []
        let repo = SongRepositorySpy()
        repo.stubbedSongs = [SongFixture.make(id: 7)]
        let sut = SongSearchPagination(
            repository: repo,
            pageSize: 20,
            debounceDuration: .zero,
            onInitialPageLoaded: { term, songs in
                captured.append((term, songs.map(\.id)))
            }
        )

        sut.term = "x"
        sut.processTermChange()
        await sut.waitForPendingSearch()

        #expect(captured.count == 1)
        #expect(captured.first?.term == "x")
        #expect(captured.first?.ids == [7])
    }

    @Test func onInitialPageLoadedIsNotInvokedOnEmptyResults() async {
        var invoked = false
        let repo = SongRepositorySpy()
        repo.stubbedSongs = []
        let sut = SongSearchPagination(
            repository: repo,
            pageSize: 20,
            debounceDuration: .zero,
            onInitialPageLoaded: { _, _ in invoked = true }
        )

        sut.term = "x"
        sut.processTermChange()
        await sut.waitForPendingSearch()

        #expect(invoked == false)
    }

    @Test func onInitialPageLoadedIsNotInvokedOnFailure() async {
        var invoked = false
        let repo = SongRepositorySpy()
        repo.errorToThrow = SampleError.network
        let sut = SongSearchPagination(
            repository: repo,
            pageSize: 20,
            debounceDuration: .zero,
            onInitialPageLoaded: { _, _ in invoked = true }
        )

        sut.term = "x"
        sut.processTermChange()
        await sut.waitForPendingSearch()

        #expect(invoked == false)
    }

    // MARK: - Helpers

    private func makeSUT(pageSize: Int = 20) -> (
        sut: SongSearchPagination,
        repository: SongRepositorySpy
    ) {
        let repo = SongRepositorySpy()
        let sut = SongSearchPagination(
            repository: repo,
            pageSize: pageSize,
            debounceDuration: .zero
        )
        return (sut, repo)
    }
}

private enum SampleError: Error, LocalizedError {
    case network
    var errorDescription: String? { "Sample network error" }
}
