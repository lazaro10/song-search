import SwiftUI
import SongAPI
import DesignSystem

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
                    DSSpinner()
                    Spacer()
                }
            case let .content(album):
                content(album: album)
            case .empty:
                DSEmptyState(
                    systemImage: "music.note.list",
                    title: "No tracks",
                    message: "This album doesn\u{2019}t have any tracks yet."
                )
            case let .error(message):
                DSEmptyState(
                    systemImage: "exclamationmark.triangle",
                    title: "Something went wrong",
                    message: message,
                    actionTitle: "Try Again",
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
                        .padding(.top, 18)
                        .padding(.bottom, 20)

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
                    .padding(.bottom, 12)

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
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
        }
    }
}
