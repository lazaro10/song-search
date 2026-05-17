import SwiftUI
import SongAPI

enum HomeBuilder {
    @MainActor
    static func build() -> some View {
        let songRepository = SongRepositoryImplementation()
        let recentlyPlayedRepository = StubRecentlyPlayedRepository()
        let searchHistoryRepository = UserDefaultsSearchHistoryRepository()
        let viewModel = HomeViewModel(
            songRepository: songRepository,
            recentlyPlayedRepository: recentlyPlayedRepository,
            searchHistoryRepository: searchHistoryRepository
        )
        return HomeView(viewModel: viewModel)
    }
}
