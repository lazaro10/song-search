import Foundation
import Observation
import SongAPI

/// Owns the search lifecycle for the Home screen: debounced term changes,
/// pagination cursor, retry on failure, and seeding from a cached snapshot.
/// Exposes the same `HomeViewState` the view binds to.
///
/// HomeViewModel composes one of these and forwards UI intents. Tests for
/// search/pagination behavior live in `SongSearchPaginationTests`; HomeViewModel
/// keeps tests only for the Home-specific concerns (recently played, snapshot
/// restoration, restored-from-cache flag).
@MainActor
@Observable
final class SongSearchPagination {
    var term: String = ""
    private(set) var state: HomeViewState = .idle
    private(set) var isPaginating = false

    private let repository: any SongRepository
    private let pageSize: Int
    private let debounceDuration: Duration
    private let onInitialPageLoaded: (String, [Song]) async -> Void

    private var currentOffset = 0
    private var hasMore = true
    private var debounceTask: Task<Void, Never>?

    init(
        repository: any SongRepository,
        pageSize: Int = 20,
        debounceDuration: Duration = .milliseconds(300),
        onInitialPageLoaded: @escaping (String, [Song]) async -> Void = { _, _ in }
    ) {
        self.repository = repository
        self.pageSize = pageSize
        self.debounceDuration = debounceDuration
        self.onInitialPageLoaded = onInitialPageLoaded
    }

    /// Call from `onChange(of: term)` in the view. Debounces and triggers an
    /// initial search; goes back to `.idle` when the term is cleared.
    func processTermChange() {
        debounceTask?.cancel()
        let trimmed = term.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            state = .idle
            return
        }
        debounceTask = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(for: self.debounceDuration)
            guard !Task.isCancelled else { return }
            await self.runInitialSearch(term: trimmed)
        }
    }

    /// Pagination hook for the last visible cell. No-op outside of the content
    /// state, when there's nothing more to fetch, or while another page is in
    /// flight. Failures are swallowed to keep the current results visible.
    func loadMoreIfNeeded() async {
        guard case let .content(songs) = state, hasMore, !isPaginating else { return }
        let trimmed = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isPaginating = true
        defer { isPaginating = false }

        do {
            let more = try await repository.searchSongs(
                term: trimmed,
                limit: pageSize,
                offset: currentOffset
            )
            currentOffset += more.count
            if more.count < pageSize { hasMore = false }
            if !more.isEmpty {
                state = .content(songs: songs + more)
            }
        } catch {
            // Silent failure on pagination — keep existing content visible.
        }
    }

    /// Re-runs the last failed search. Wired to the "Try Again" button in the
    /// error state.
    func retry() async {
        debounceTask?.cancel()
        let trimmed = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        await runInitialSearch(term: trimmed)
    }

    /// Seeds the state with a previously cached snapshot without hitting the
    /// network. Caller is expected to set the term separately if needed.
    /// Disables pagination since the cached snapshot may not be a full page.
    func seedFromCache(songs: [Song]) {
        guard term.isEmpty, state == .idle else { return }
        state = .content(songs: songs)
        currentOffset = songs.count
        hasMore = false
    }

    /// Test hook: awaits any in-flight debounced search.
    func waitForPendingSearch() async {
        _ = await debounceTask?.value
    }

    private func runInitialSearch(term: String) async {
        state = .loading
        currentOffset = 0
        hasMore = true
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
