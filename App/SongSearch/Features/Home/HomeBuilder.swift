import SwiftUI
import SongAPI
import Storage

enum HomeBuilder {
    @MainActor
    static func build(
        songRepository: any SongRepository,
        recentlyPlayedRepository: any RecentlyPlayedRepository
    ) -> some View {
        let searchHistoryRepository = UserDefaultsSearchHistoryRepository()
        let viewModel = HomeViewModel(
            songRepository: songRepository,
            recentlyPlayedRepository: recentlyPlayedRepository,
            searchHistoryRepository: searchHistoryRepository
        )
        return HomeView(viewModel: viewModel)
    }
}
