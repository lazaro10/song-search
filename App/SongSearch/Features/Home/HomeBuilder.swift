import SwiftUI
import SongAPI
import Storage

enum HomeBuilder {
    @MainActor
    static func build(
        songRepository: any SongRepository,
        recentlyPlayedRepository: any RecentlyPlayedRepository,
        searchHistoryRepository: any SearchHistoryRepository
    ) -> some View {
        let viewModel = HomeViewModel(
            songRepository: songRepository,
            recentlyPlayedRepository: recentlyPlayedRepository,
            searchHistoryRepository: searchHistoryRepository
        )
        return HomeView(viewModel: viewModel)
    }
}
