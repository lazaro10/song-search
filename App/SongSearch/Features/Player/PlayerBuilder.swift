import SwiftUI
import SongAPI
import AudioPlayer
import Storage

enum PlayerBuilder {
    @MainActor
    static func build(
        song: Song,
        recentlyPlayedRepository: any RecentlyPlayedRepository
    ) -> some View {
        let viewModel = PlayerViewModel(
            song: song,
            audioPlayer: AudioPlayerImplementation(),
            recentlyPlayedRepository: recentlyPlayedRepository
        )
        return PlayerView(viewModel: viewModel)
    }
}
