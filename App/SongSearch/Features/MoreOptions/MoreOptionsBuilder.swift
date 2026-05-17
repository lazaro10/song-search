import SwiftUI
import SongAPI

enum MoreOptionsBuilder {
    @MainActor
    static func build(
        song: Song,
        onSelectAlbum: @escaping (Int) -> Void
    ) -> some View {
        let viewModel = MoreOptionsViewModel(
            song: song,
            recentlyPlayedRepository: StubRecentlyPlayedRepository()
        )
        return MoreOptionsView(viewModel: viewModel, onSelectAlbum: onSelectAlbum)
    }
}
