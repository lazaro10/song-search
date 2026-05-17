import SwiftUI
import SongAPI

enum PlayerBuilder {
    @MainActor
    static func build(song: Song) -> some View {
        let viewModel = PlayerViewModel(song: song)
        return PlayerView(viewModel: viewModel)
    }
}
