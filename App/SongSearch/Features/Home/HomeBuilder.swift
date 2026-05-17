import SwiftUI
import SongAPI
import Storage

enum HomeBuilder {
    @MainActor
    static func build(recentlyPlayedRepository: any RecentlyPlayedRepository) -> some View {
        let songRepository = SongRepositoryImplementation()
        let searchHistoryRepository = UserDefaultsSearchHistoryRepository()
        let viewModel = HomeViewModel(
            songRepository: songRepository,
            recentlyPlayedRepository: recentlyPlayedRepository,
            searchHistoryRepository: searchHistoryRepository
        )
        return HomeView(viewModel: viewModel)
    }
}
