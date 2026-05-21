import Foundation
import Observation
import SongAPI

@MainActor
@Observable
final class SongSearchPagination {
    var term: String = ""
    private(set) var state: HomeViewState = .idle
    private(set) var isPaginating = false
    private(set) var paginationError: String?

    private let repository: any SongSearchRepository
    private let pageSize: Int
    private let debounceDuration: Duration
    private let onInitialPageLoaded: (String, [Song]) async -> Void

    private var activeTerm: String = ""
    private var currentOffset = 0
    private var hasMore = true
    private var debounceTask: Task<Void, Never>?

    init(
        repository: any SongSearchRepository,
        pageSize: Int = 20,
        debounceDuration: Duration = .milliseconds(300),
        onInitialPageLoaded: @escaping (String, [Song]) async -> Void = { _, _ in }
    ) {
        self.repository = repository
        self.pageSize = pageSize
        self.debounceDuration = debounceDuration
        self.onInitialPageLoaded = onInitialPageLoaded
    }

    func processTermChange() {
        debounceTask?.cancel()
        let trimmed = term.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            state = .idle
            activeTerm = ""
            return
        }
        debounceTask = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(for: self.debounceDuration)
            guard !Task.isCancelled else { return }
            await self.runInitialSearch(term: trimmed)
        }
    }

    func loadMoreIfNeeded() async {
        guard case let .content(songs) = state, hasMore, !isPaginating else { return }
        guard !activeTerm.isEmpty else { return }

        isPaginating = true
        paginationError = nil
        defer { isPaginating = false }

        do {
            let more = try await repository.searchSongs(
                term: activeTerm,
                limit: pageSize,
                offset: currentOffset
            )
            currentOffset += more.count
            if more.count < pageSize { hasMore = false }
            if !more.isEmpty {
                state = .content(songs: songs + more)
            }
        } catch {
            paginationError = error.localizedDescription
        }
    }

    func retryPagination() async {
        paginationError = nil
        await loadMoreIfNeeded()
    }

    func retry() async {
        debounceTask?.cancel()
        let trimmed = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        await runInitialSearch(term: trimmed)
    }

    func seedFromCache(term: String, songs: [Song]) {
        guard self.term.isEmpty, state == .idle else { return }
        activeTerm = term
        state = .content(songs: songs)
        currentOffset = songs.count
        hasMore = songs.count == pageSize
        paginationError = nil
    }

    func waitForPendingSearch() async {
        _ = await debounceTask?.value
    }

    private func runInitialSearch(term: String) async {
        activeTerm = term
        state = .loading
        currentOffset = 0
        hasMore = true
        paginationError = nil
        do {
            let songs = try await repository.searchSongs(
                term: term,
                limit: pageSize,
                offset: 0
            )
            currentOffset = songs.count
            hasMore = songs.count == pageSize
            if songs.isEmpty {
                state = .empty
            } else {
                state = .content(songs: songs)
                await onInitialPageLoaded(term, songs)
            }
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }
}
