import Foundation
import Observation
import SongAPI
import Storage

@MainActor
@Observable
final class HomeViewModel {
    let recentlyPlayedRepository: any RecentlyPlayedRepository
    let search: SongSearchPagination

    private(set) var recentlyPlayed: [Song] = []
    private(set) var restoredFromCache = false

    private let searchHistoryRepository: any SearchHistoryRepository

    init(
        songSearchRepository: any SongSearchRepository,
        recentlyPlayedRepository: any RecentlyPlayedRepository,
        searchHistoryRepository: any SearchHistoryRepository,
        pageSize: Int = 20,
        debounceDuration: Duration = .milliseconds(300)
    ) {
        self.recentlyPlayedRepository = recentlyPlayedRepository
        self.searchHistoryRepository = searchHistoryRepository
        self.search = SongSearchPagination(
            repository: songSearchRepository,
            pageSize: pageSize,
            debounceDuration: debounceDuration,
            onInitialPageLoaded: { [searchHistoryRepository] term, songs in
                await searchHistoryRepository.save(term: term, songs: songs)
            }
        )
    }

    func onAppear() async {
        async let recent: Void = loadRecentlyPlayed()
        async let history: Void = restoreLastSearch()
        _ = await (recent, history)
    }

    /// View hook: called from `.onChange(of: search.term)`. Clears the
    /// "restored from cache" hint so the section header renders correctly
    /// and forwards the term change to the pagination engine.
    func processSearchTermChange() {
        restoredFromCache = false
        search.processTermChange()
    }

    private func loadRecentlyPlayed() async {
        recentlyPlayed = await recentlyPlayedRepository.recentSongs(limit: 10)
    }

    private func restoreLastSearch() async {
        guard let snapshot = await searchHistoryRepository.lastSearch() else { return }
        search.seedFromCache(term: snapshot.term, songs: snapshot.songs)
        if case .content = search.state {
            restoredFromCache = true
        }
    }
}
