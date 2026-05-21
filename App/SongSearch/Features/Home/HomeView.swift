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
                    .padding(.horizontal, DSSpacing.spacious)
                    .padding(.top, DSSpacing.small)
                    .padding(.bottom, DSSpacing.medium)

                HomeSearchBar(text: $search.term)
                    .padding(.horizontal, DSSpacing.spacious)
                    .padding(.bottom, DSSpacing.large)

                if search.term.isEmpty, !viewModel.recentlyPlayed.isEmpty {
                    RecentlyPlayedRail(songs: viewModel.recentlyPlayed)
                }

                resultsSection
            }
            .padding(.bottom, DSSpacing.huge)
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
                .padding(.top, DSSpacing.big)
            }

        case .loading:
            HStack { Spacer(); DSSpinner(); Spacer() }
                .padding(.vertical, DSSpacing.huge)

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
                    // Trigger pagination a few rows before the bottom so the
                    // next page is already arriving by the time the user gets
                    // there. `loadMoreIfNeeded` self-guards via isPaginating.
                    if index == max(0, songs.count - 3) {
                        Task { await viewModel.search.loadMoreIfNeeded() }
                    }
                }
            }

            paginationFooter
                .padding(.vertical, DSSpacing.large)

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

    @ViewBuilder
    private var paginationFooter: some View {
        if viewModel.search.isPaginating {
            VStack(spacing: DSSpacing.small) {
                DSSpinner()
                Text("Loading more songs…")
                    .font(.dsCaptionSmall)
                    .foregroundStyle(palette.textSecondary)
            }
            .frame(maxWidth: .infinity)
        } else if let message = viewModel.search.paginationError {
            VStack(spacing: DSSpacing.small) {
                Text(message)
                    .font(.dsCaptionSmall)
                    .foregroundStyle(palette.textSecondary)
                    .multilineTextAlignment(.center)
                Button("Tap to retry") {
                    Task { await viewModel.search.retryPagination() }
                }
                .font(.dsCaption)
                .tint(.accentColor)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
