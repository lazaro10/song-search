import SwiftUI
import SongAPI

enum HomeBuilder {
    @MainActor
    static func build() -> some View {
        let songRepository = SongRepositoryImplementation()
        let recentlyPlayedRepository = StubRecentlyPlayedRepository()
        let viewModel = HomeViewModel(
            songRepository: songRepository,
            recentlyPlayedRepository: recentlyPlayedRepository
        )
        return HomeView(viewModel: viewModel)
    }
}
