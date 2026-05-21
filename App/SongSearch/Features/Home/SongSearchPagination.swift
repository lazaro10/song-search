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
    /// User-facing input bound to the search field. Empty on a fresh launch,
    /// stays empty after a cache-seeded restoration so the field doesn't
    /// "look pre-filled" while the saved results are showing.
    var term: String = ""
    private(set) var state: HomeViewState = .idle
    private(set) var isPaginating = false
    /// Non-nil when the last `loadMoreIfNeeded` failed. The content state is
    /// preserved so the user keeps seeing what they had; the view shows a
    /// retry affordance based on this.
    private(set) var paginationError: String?

    private let repository: any SongRepository
    private let pageSize: Int
    private let debounceDuration: Duration
    private let onInitialPageLoaded: (String, [Song]) async -> Void

    /// The term the current `state` represents. Tracked separately from `term`
    /// so pagination works after a cache restore, where `term` is empty but the
    /// content was fetched for some prior query.
    private var activeTerm: String = ""
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

    /// Pagination hook for the last visible cell. No-op outside of the content
    /// state, when there's nothing more to fetch, or while another page is in
    /// flight. Keeps the current results visible on failure and surfaces the
    /// error via `paginationError` so the view can offer a retry.
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

    /// View hook for the "tap to retry" affordance on the pagination footer.
    /// Clears the previous error and re-runs `loadMoreIfNeeded`.
    func retryPagination() async {
        paginationError = nil
        await loadMoreIfNeeded()
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
    /// network. The seeded `term` becomes the engine's active term so
    /// pagination keeps working as the user scrolls — `loadMoreIfNeeded` will
    /// fetch the next page under the same term. The user-facing `term` input
    /// stays untouched.
    ///
    /// Pagination is enabled when the snapshot contains a full page; a short
    /// snapshot is assumed to be the final page.
    func seedFromCache(term: String, songs: [Song]) {
        guard self.term.isEmpty, state == .idle else { return }
        activeTerm = term
        state = .content(songs: songs)
        currentOffset = songs.count
        hasMore = songs.count == pageSize
        paginationError = nil
    }

    /// Test hook: awaits any in-flight debounced search.
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
