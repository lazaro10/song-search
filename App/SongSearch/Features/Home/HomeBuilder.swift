import SwiftUI
import SongAPI
import Storage

enum HomeBuilder {
    @MainActor
    static func build(
        songSearchRepository: any SongSearchRepository,
        recentlyPlayedRepository: any RecentlyPlayedRepository,
        searchHistoryRepository: any SearchHistoryRepository
    ) -> some View {
        let viewModel = HomeViewModel(
            songSearchRepository: songSearchRepository,
            recentlyPlayedRepository: recentlyPlayedRepository,
            searchHistoryRepository: searchHistoryRepository
        )
        return HomeView(viewModel: viewModel)
    }
}
