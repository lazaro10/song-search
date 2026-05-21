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
            SongSearchRepositorySpy.SearchCall(term: "beatles", limit: 20, offset: 0),
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

    @Test func loadMoreKeepsExistingContentAndSurfacesPaginationErrorOnFailure() async {
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
        #expect(sut.paginationError == SampleError.network.localizedDescription)
    }

    @Test func retryPaginationClearsErrorAndReRunsFetch() async {
        let (sut, repo) = makeSUT(pageSize: 2)
        repo.stubbedSongs = [
            SongFixture.make(id: 1),
            SongFixture.make(id: 2),
        ]
        sut.term = "x"
        sut.processTermChange()
        await sut.waitForPendingSearch()

        repo.errorToThrow = SampleError.network
        await sut.loadMoreIfNeeded()
        #expect(sut.paginationError != nil)

        repo.errorToThrow = nil
        repo.stubbedSongs = [
            SongFixture.make(id: 3),
            SongFixture.make(id: 4),
        ]
        await sut.retryPagination()

        #expect(sut.paginationError == nil)
        if case let .content(songs) = sut.state {
            #expect(songs.map(\.id) == [1, 2, 3, 4])
        } else {
            Issue.record("Expected .content with new page, got \(sut.state)")
        }
    }

    @Test func successfulLoadMoreClearsPriorPaginationError() async {
        let (sut, repo) = makeSUT(pageSize: 2)
        repo.stubbedSongs = [SongFixture.make(id: 1), SongFixture.make(id: 2)]
        sut.term = "x"
        sut.processTermChange()
        await sut.waitForPendingSearch()

        repo.errorToThrow = SampleError.network
        await sut.loadMoreIfNeeded()
        #expect(sut.paginationError != nil)

        repo.errorToThrow = nil
        repo.stubbedSongs = [SongFixture.make(id: 3)]
        await sut.loadMoreIfNeeded()

        #expect(sut.paginationError == nil)
    }

    @Test func initialSearchClearsPriorPaginationError() async {
        let (sut, repo) = makeSUT(pageSize: 2)
        repo.stubbedSongs = [SongFixture.make(id: 1), SongFixture.make(id: 2)]
        sut.term = "x"
        sut.processTermChange()
        await sut.waitForPendingSearch()

        repo.errorToThrow = SampleError.network
        await sut.loadMoreIfNeeded()
        #expect(sut.paginationError != nil)

        repo.errorToThrow = nil
        repo.stubbedSongs = [SongFixture.make(id: 99)]
        sut.term = "y"
        sut.processTermChange()
        await sut.waitForPendingSearch()

        #expect(sut.paginationError == nil)
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

    @Test func seedFromCacheSetsContentAndDisablesPaginationWhenSnapshotIsShorterThanPage() async {
        let (sut, repo) = makeSUT(pageSize: 20)
        let songs = [SongFixture.make(id: 1), SongFixture.make(id: 2)]

        sut.seedFromCache(term: "beatles", songs: songs)
        await sut.loadMoreIfNeeded()

        if case let .content(state) = sut.state {
            #expect(state.map(\.id) == [1, 2])
        } else {
            Issue.record("Expected .content from seed, got \(sut.state)")
        }
        #expect(repo.searchCalls.isEmpty)
    }

    @Test func seedFromCacheEnablesPaginationWhenSnapshotIsAFullPage() async {
        let (sut, repo) = makeSUT(pageSize: 2)
        let cached = [SongFixture.make(id: 1), SongFixture.make(id: 2)]

        sut.seedFromCache(term: "beatles", songs: cached)
        repo.stubbedSongs = [SongFixture.make(id: 3), SongFixture.make(id: 4)]
        await sut.loadMoreIfNeeded()

        #expect(repo.searchCalls == [
            SongSearchRepositorySpy.SearchCall(term: "beatles", limit: 2, offset: 2),
        ])
        if case let .content(songs) = sut.state {
            #expect(songs.map(\.id) == [1, 2, 3, 4])
        } else {
            Issue.record("Expected paginated .content, got \(sut.state)")
        }
    }

    @Test func seedFromCachePaginationUsesSeededTermNotUserInput() async {
        let (sut, repo) = makeSUT(pageSize: 2)
        sut.seedFromCache(term: "beatles", songs: [SongFixture.make(id: 1), SongFixture.make(id: 2)])

        repo.stubbedSongs = [SongFixture.make(id: 3)]
        await sut.loadMoreIfNeeded()

        #expect(repo.searchCalls.last?.term == "beatles")
        #expect(sut.term.isEmpty)
    }

    @Test func seedFromCacheIsIgnoredWhenTermIsNotEmpty() {
        let (sut, _) = makeSUT()
        sut.term = "active query"
        sut.seedFromCache(term: "beatles", songs: [SongFixture.make(id: 1)])

        #expect(sut.state == .idle)
    }

    @Test func onInitialPageLoadedCallbackIsInvokedOnSuccess() async {
        var captured: [(term: String, ids: [Int])] = []
        let repo = SongSearchRepositorySpy()
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
        let repo = SongSearchRepositorySpy()
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
        let repo = SongSearchRepositorySpy()
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

    private func makeSUT(pageSize: Int = 20) -> (
        sut: SongSearchPagination,
        repository: SongSearchRepositorySpy
    ) {
        let repo = SongSearchRepositorySpy()
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
