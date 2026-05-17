import SwiftUI
import SongAPI
import AudioPlayer

enum PlayerBuilder {
    @MainActor
    static func build(song: Song) -> some View {
        let viewModel = PlayerViewModel(
            song: song,
            audioPlayer: AudioPlayerImplementation()
        )
        return PlayerView(viewModel: viewModel)
    }
}
