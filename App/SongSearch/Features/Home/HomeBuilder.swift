import SwiftUI
import SongAPI

enum HomeBuilder {
    @MainActor
    static func build() -> some View {
        let songRepository = SongRepositoryImplementation()
        let viewModel = HomeViewModel(songRepository: songRepository)
        return HomeView(viewModel: viewModel)
    }
}
