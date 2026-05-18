import SwiftUI
import SongAPI
import DesignSystem

struct HomeView: View {
    @Environment(\.dsPalette) private var palette
    @Environment(AppRouter.self) private var router
    @Bindable var viewModel: HomeViewModel
    @State private var selectedSongForOptions: Song?

    var body: some View {
        @Bindable var search = viewModel.search

        ScrollView {
            LazyVStack(spacing: 0) {
                HomeTitleBar()
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 14)

                HomeSearchBar(text: $search.term)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 18)

                if search.term.isEmpty, !viewModel.recentlyPlayed.isEmpty {
                    RecentlyPlayedRail(songs: viewModel.recentlyPlayed)
                }

                resultsSection
            }
            .padding(.bottom, 32)
        }
        .background(palette.background.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.onAppear()
        }
        .onChange(of: search.term) { _, _ in
            viewModel.processSearchTermChange()
        }
        .sheet(item: $selectedSongForOptions) { song in
            MoreOptionsBuilder.build(song: song) { albumId in
                router.navigate(to: .album(collectionId: albumId))
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }

    @ViewBuilder
    private var resultsSection: some View {
        switch viewModel.search.state {
        case .idle:
            if viewModel.recentlyPlayed.isEmpty {
                DSEmptyState(
                    systemImage: "magnifyingglass",
                    title: "Search for a song",
                    message: "Type a song or artist name above to start exploring."
                )
                .padding(.top, 24)
            }

        case .loading:
            HStack { Spacer(); DSSpinner(); Spacer() }
                .padding(.vertical, 40)

        case let .content(songs):
            if !viewModel.restoredFromCache {
                DSSectionHeader(title: "Results for \u{201C}\(viewModel.search.term)\u{201D}")
            }

            ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
                NavigationLink(value: AppRoute.player(song)) {
                    SongRow(
                        song: song,
                        showDivider: index < songs.count - 1,
                        onMore: { selectedSongForOptions = song }
                    )
                }
                .buttonStyle(.plain)
                .onAppear {
                    if song.id == songs.last?.id {
                        Task { await viewModel.search.loadMoreIfNeeded() }
                    }
                }
            }

            if viewModel.search.isPaginating {
                VStack(spacing: 6) {
                    DSSpinner()
                    Text("Loading more songs…")
                        .font(.dsCaptionSmall)
                        .foregroundStyle(palette.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
            }

        case .empty:
            DSEmptyState(
                systemImage: "music.note.list",
                title: "No songs found",
                message: "We couldn\u{2019}t find anything for \u{201C}\(viewModel.search.term)\u{201D}. Try a different song or artist."
            )

        case let .error(message):
            DSEmptyState(
                systemImage: "exclamationmark.triangle",
                title: "Something went wrong",
                message: message,
                actionTitle: "Try Again",
                action: { Task { await viewModel.search.retry() } }
            )
        }
    }
}
