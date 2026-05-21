import SwiftUI
import SongAPI
import DesignSystem
import Localization

struct AlbumView: View {
    @Environment(\.dsPalette) private var palette
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var router

    @Bindable var viewModel: AlbumViewModel

    var body: some View {
        ZStack {
            palette.background.ignoresSafeArea()

            switch viewModel.state {
            case .idle, .loading:
                VStack {
                    Spacer()
                    DSSpinner(accessibilityLabel: L10n.A11y.loading)
                    Spacer()
                }
            case let .content(album):
                content(album: album)
            case .empty:
                DSEmptyState(
                    icon: .trackList,
                    title: L10n.Album.noTracksTitle,
                    message: L10n.Album.noTracksMessage
                )
            case let .error(message):
                DSEmptyState(
                    icon: .warning,
                    title: L10n.Common.errorTitle,
                    message: message,
                    actionTitle: L10n.Common.tryAgain,
                    action: { Task { await viewModel.start() } }
                )
            }

            VStack {
                AlbumTopBar(onBack: { dismiss() })
                Spacer()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.start()
        }
    }

    @ViewBuilder
    private func content(album: Album) -> some View {
        ZStack {
            AlbumBackdrop(artworkURL: album.artworkURL)

            ScrollView {
                VStack(spacing: 0) {
                    Color.clear.frame(height: 60)

                    AlbumHeader(album: album)
                        .padding(.top, DSSpacing.large)
                        .padding(.bottom, DSSpacing.spacious)

                    AlbumActions(
                        onPlay: {
                            if let first = album.songs.first {
                                router.navigate(to: .player(first))
                            }
                        },
                        onShuffle: {
                            if let random = album.songs.randomElement() {
                                router.navigate(to: .player(random))
                            }
                        }
                    )
                    .padding(.bottom, DSSpacing.medium)

                    LazyVStack(spacing: 0) {
                        ForEach(Array(album.songs.enumerated()), id: \.element.id) { index, song in
                            NavigationLink(value: AppRoute.player(song)) {
                                AlbumTrackRow(
                                    number: index + 1,
                                    song: song,
                                    showDivider: index < album.songs.count - 1
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, DSSpacing.spacious)
                    .padding(.bottom, DSSpacing.huge)
                }
            }
        }
    }
}
