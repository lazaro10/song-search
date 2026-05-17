import SwiftUI
import SongAPI

enum MoreOptionsBuilder {
    @MainActor
    static func build(
        song: Song,
        onSelectAlbum: @escaping (Int) -> Void
    ) -> some View {
        let viewModel = MoreOptionsViewModel(song: song)
        return MoreOptionsView(viewModel: viewModel, onSelectAlbum: onSelectAlbum)
    }
}
