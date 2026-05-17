import SwiftUI
import SongAPI
import DesignSystem

struct PlayerView: View {
    @Environment(\.dsPalette) private var palette
    @Environment(\.dismiss) private var dismiss

    let viewModel: PlayerViewModel
    @State private var showingMoreOptions = false

    var body: some View {
        ZStack {
            PlayerBackdrop(artworkURL: viewModel.song.artworkURL)

            VStack(spacing: 0) {
                PlayerTopBar(
                    onBack: { dismiss() },
                    onMore: { showingMoreOptions = true }
                )

                PlayerArtwork(
                    artworkURL: viewModel.song.artworkURL,
                    isPlaying: viewModel.isPlaying
                )

                VStack(spacing: 4) {
                    Text(viewModel.song.name)
                        .font(.dsScreenTitle)
                        .foregroundStyle(palette.text)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    Text(viewModel.song.artistName)
                        .font(.dsItemTitle)
                        .foregroundStyle(palette.textSecondary)
                        .lineLimit(1)
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)

                PlayerProgress(
                    currentTime: viewModel.currentTime,
                    duration: viewModel.duration
                )
                .padding(.top, 24)

                PlayerControls(
                    isPlaying: viewModel.isPlaying,
                    onPlayPause: { viewModel.togglePlayPause() },
                    onSkipBack: { viewModel.skipBackward() },
                    onSkipForward: { viewModel.skipForward() }
                )

                Spacer(minLength: 16)

                PlayerAlbumPill(song: viewModel.song)
                    .padding(.bottom, 24)
            }

            if let message = viewModel.errorMessage {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.dsCaption)
                        .foregroundStyle(palette.textSecondary)
                        .padding()
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.start()
        }
        .sheet(isPresented: $showingMoreOptions) {
            MoreOptionsView(song: viewModel.song)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}
