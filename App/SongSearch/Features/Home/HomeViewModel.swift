import Foundation
import Observation
import SongAPI
import Storage

@MainActor
@Observable
final class HomeViewModel {
    var searchTerm: String = ""
    private(set) var state: HomeViewState = .idle
    private(set) var isPaginating = false
    private(set) var recentlyPlayed: [Song] = []
    private(set) var restoredFromCache = false

    private let songRepository: SongRepository
    let recentlyPlayedRepository: any RecentlyPlayedRepository
    private let searchHistoryRepository: SearchHistoryRepository
    private let pageSize: Int
    private let debounceDuration: Duration

    private var currentOffset = 0
    private var hasMore = true
    private var debounceTask: Task<Void, Never>?

    init(
        songRepository: SongRepository,
        recentlyPlayedRepository: any RecentlyPlayedRepository,
        searchHistoryRepository: SearchHistoryRepository,
        pageSize: Int = 20,
        debounceDuration: Duration = .milliseconds(300)
    ) {
        self.songRepository = songRepository
        self.recentlyPlayedRepository = recentlyPlayedRepository
        self.searchHistoryRepository = searchHistoryRepository
        self.pageSize = pageSize
        self.debounceDuration = debounceDuration
    }

    func onAppear() async {
        async let recent: Void = loadRecentlyPlayed()
        async let history: Void = restoreLastSearch()
        _ = await (recent, history)
    }

    func processSearchTermChange() {
        restoredFromCache = false
        debounceTask?.cancel()
        let trimmed = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
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

    func loadMoreIfNeeded() async {
        guard case let .content(songs) = state, hasMore, !isPaginating else { return }
        let trimmed = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isPaginating = true
        defer { isPaginating = false }

        do {
            let more = try await songRepository.searchSongs(
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

    // Test hook: awaits any in-flight debounced search.
    func waitForPendingSearch() async {
        _ = await debounceTask?.value
    }

    private func loadRecentlyPlayed() async {
        recentlyPlayed = await recentlyPlayedRepository.recentSongs(limit: 10)
    }

    private func restoreLastSearch() async {
        guard let snapshot = await searchHistoryRepository.lastSearch() else { return }
        guard searchTerm.isEmpty, state == .idle else { return }
        state = .content(songs: snapshot.songs)
        restoredFromCache = true
        currentOffset = snapshot.songs.count
        hasMore = false
    }

    private func runInitialSearch(term: String) async {
        state = .loading
        currentOffset = 0
        hasMore = true
        do {
            let songs = try await songRepository.searchSongs(
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
                await searchHistoryRepository.save(term: term, songs: songs)
            }
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }
}
