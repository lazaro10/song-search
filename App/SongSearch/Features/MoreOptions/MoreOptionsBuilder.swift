import SwiftUI
import SongAPI
import Storage

enum MoreOptionsBuilder {
    @MainActor
    static func build(
        song: Song,
        recentlyPlayedRepository: any RecentlyPlayedRepository,
        onSelectAlbum: @escaping (Int) -> Void
    ) -> some View {
        let viewModel = MoreOptionsViewModel(
            song: song,
            recentlyPlayedRepository: recentlyPlayedRepository
        )
        return MoreOptionsView(viewModel: viewModel, onSelectAlbum: onSelectAlbum)
    }
}
